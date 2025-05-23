## 2x2 MIMO-OFDM Simulation with MMSE Detection

This project simulates a 2x2 MIMO-OFDM wireless communication system in MATLAB using QPSK modulation and MMSE detection. The goal is to evaluate the Bit Error Rate (BER) performance over a range of Signal-to-Noise Ratios (SNRs)

---
## 📌 Key Features

- **MIMO System**: 2 transmit and 2 receive antennas  
- **OFDM Parameters**: 64 subcarriers, 16-point cyclic prefix  
- **Modulation**: QPSK  
- **Detection**: Minimum Mean Square Error (MMSE)  
- **Channel**: Frequency-selective Rayleigh fading  
- **Output**: BER vs. SNR performance curve
---

## 🧠 Concepts Explained

| Term              | Description |
|-------------------|-------------|
| **OFDM**          | Orthogonal Frequency Division Multiplexing splits a signal into multiple subcarriers to reduce multipath effects. |
| **MIMO**          | Multiple antennas at both the transmitter and receiver improve reliability and increase data rates. |
| **QPSK**          | Quadrature Phase Shift Keying transmits 2 bits per symbol by shifting the phase of the carrier. |
| **Cyclic Prefix** | A portion of the OFDM symbol added to combat inter-symbol interference due to multipath. |
| **MMSE Detection**| A linear method used at the receiver to minimize the mean square error in symbol estimation. |
| **SNR (dB)**      | Signal-to-Noise Ratio in decibels; measures how strong the signal is relative to background noise. |
| **BER**           | Bit Error Rate; the ratio of bit errors to total transmitted bits, used to quantify communication performance. |

---
## ⚙️ System Parameters
num_tx = 2;         % Number of transmit antennas  
num_rx = 2;         % Number of receive antennas  
Nfft   = 64;        % Number of OFDM subcarriers  
cp_len = 16;        % Cyclic prefix length  
mod_order = 4;      % QPSK  
num_symbols = 100;  % Number of OFDM symbols per frame  
snr_db = 0:5:30;    % SNR range in dB  

---

## 📊 BER vs SNR Plot

![image](https://github.com/user-attachments/assets/6022de2e-8945-444a-9dde-889afbc23242)

---

## 📁 Files Included

* `mimo_ofdm_mmse.m`: MATLAB simulation script
* `README.md`: Project overview
* `BER_plot.png`: Output plot image (above)

---

## 🚀 How to Run

1. Open the script in **MATLAB**.
2. Run the file using:

   ```matlab
   mimo_ofdm_mmse
   ```
3. The BER vs SNR plot will be generated automatically.

---

## 🧾 License

This project is intended for academic and educational purposes. You are free to use, modify, and extend the code with proper attribution.

---

## 🙋‍♂️ Acknowledgments

Inspired by foundational principles in digital communications, MIMO systems, and modern wireless technologies including LTE and 5G.

```
