This file contains the encoder & decoder of Turbo code (aka PCCC) using message passing based on two log-domain BCJR decoders.
Single BCJR decoder also decodes convolutional codes (NR & SR).

*****FILE LIST****
- mogen_log_map_bcjr(): the BCJR decoder
- NR_encoder: non-systematic non-recursive convo. encoder
- SR_encoder: sysmatic recursive convo. encoder
- turbo_encoder: Turbo encoder
- turbo_decoder: Turbo decoder, supprting two identical constituent SR convo. encoder with or without puncturing.

 