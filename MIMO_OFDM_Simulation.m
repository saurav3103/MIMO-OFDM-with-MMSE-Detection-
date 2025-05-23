clc; clear; close all;

%% System Parameters
num_tx = 2;         % Number of transmit antennas
num_rx = 2;         % Number of receive antennas
Nfft   = 64;        % Number of OFDM subcarriers
cp_len = 16;        % Cyclic prefix length
mod_order = 4;      % QPSK => 4
num_symbols = 100;  % OFDM symbols per frame
snr_db = 0:5:30;    % SNR range in dB
channel_taps = 4;   % Number of taps in time-domain MIMO channel

%% Modulation
k_mod = log2(mod_order);
modObj = comm.QPSKModulator('BitInput', true);
demodObj = comm.QPSKDemodulator('BitOutput', true);

%% BER result storage
ber = zeros(1, length(snr_db));

%% Main loop over SNR
for s = 1:length(snr_db)
    snr = 10^(snr_db(s)/10);
    total_errors = 0;
    total_bits = 0;
    
    for n = 1:num_symbols
        %% Transmitter
        bits_tx = randi([0 1], Nfft * k_mod * num_tx, 1);
        symbols_tx = reshape(bits_tx, [], num_tx);
        
        x_mod = zeros(Nfft, num_tx);
        for t = 1:num_tx
            x_mod(:,t) = step(modObj, symbols_tx(:,t));
        end
        
        x_ifft = ifft(x_mod, Nfft);
        x_cp = [x_ifft(end-cp_len+1:end, :); x_ifft];  % Add CP
        
        %% Time-domain MIMO channel
        H_time = (randn(channel_taps, num_rx, num_tx) + 1j * randn(channel_taps, num_rx, num_tx)) / sqrt(2 * channel_taps);
        
        y_time = zeros(Nfft + cp_len + channel_taps - 1, num_rx);
        for rx = 1:num_rx
            for tx = 1:num_tx
                h = squeeze(H_time(:, rx, tx));
                y_time(:,rx) = y_time(:,rx) + conv(x_cp(:,tx), h);
            end
        end
        
        %% Add noise
        noise_power = mean(abs(y_time).^2, 'all') / snr;
        noise = sqrt(noise_power/2) * (randn(size(y_time)) + 1j * randn(size(y_time)));
        y_time = y_time + noise;
        
        %% Receiver
        % Align signal (remove CP)
        y_no_cp = y_time(cp_len+1 : cp_len+Nfft, :);
        
        % FFT
        y_fft = fft(y_no_cp, Nfft);
        
        % Frequency response for each subcarrier
        H_freq = zeros(num_rx, num_tx, Nfft);
        for rx = 1:num_rx
            for tx = 1:num_tx
                h = squeeze(H_time(:,rx,tx));
                H_freq(rx,tx,:) = fft(h, Nfft);
            end
        end
        
        % MMSE Detection
        x_est = zeros(Nfft, num_tx);
        for k = 1:Nfft
            Hk = H_freq(:,:,k);
            yk = y_fft(k,:).';
            Wk = (Hk' * Hk + (1/snr) * eye(num_tx)) \ (Hk');
            xk_est = Wk * yk;
            x_est(k,:) = xk_est.';
        end
        
        % Normalize
        x_est = x_est / sqrt(mean(abs(x_est).^2, 'all'));
        
        % Demodulate
        bits_rx = zeros(Nfft * k_mod * num_tx, 1);
        for t = 1:num_tx
            bits_rx((t-1)*Nfft*k_mod+1 : t*Nfft*k_mod) = step(demodObj, x_est(:,t));
        end
        
        total_errors = total_errors + sum(bits_rx ~= bits_tx);
        total_bits = total_bits + length(bits_tx);
    end
    
    ber(s) = total_errors / total_bits;
    fprintf("SNR = %2d dB, BER = %.4e\n", snr_db(s), ber(s));
end

%% Plot results
semilogy(snr_db, ber, 'b-o', 'LineWidth', 2);
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs SNR for 2x2 MIMO-OFDM with MMSE Detection');
