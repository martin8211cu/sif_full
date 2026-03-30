rem 1. Make a self-signed certificate called soinCA.cer.
MakeCert -sv soinCA.pvk -r -n "CN=SOIN Soluciones Integrales S.A. Autenticador" soinCA.cer
rem Make an SPC file using Cert2SPC.
Cert2SPC soinCA.cer soinCA.spc

rem 2. Make another self-signed certificate called soin.cer.
MakeCert -sv soin.pvk -r -n "CN=SOIN Soluciones Integrales S.A." soin.cer
rem Make an SPC file using Cert2SPC.
Cert2SPC soin.cer soin.spc

rem 3. Make a soin.ctl from soin.cer.
MakeCTL soin.cer soin.ctl

rem 4. Sign soin.ctl with the soinCA.pvk and soinCA.spc made in step 1.
SignCode -v soinCA.pvk -spc soinCA.spc soin.ctl

rem 5. Move soin.ctl to the trust system store.
CertMgr -add -ctl soin.ctl -s trust

rem 6. Move soinCA.cer to the root system store.
CertMgr -add -c soinCA.cer -s root

rem 7. Sign something (soinPrintDocs.cab) with soin.pvk, and soin.spc.
SignCode -v soin.pvk -spc soin.spc soinPrintDocs.cab

rem 8. Since soin.cer is in the soin.ctl, ChkTrust will succeed.
ChkTrust soinPrintDocs.cab 
