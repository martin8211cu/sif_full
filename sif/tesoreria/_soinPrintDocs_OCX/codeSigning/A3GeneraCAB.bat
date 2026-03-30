rem 7. Sign something (soinPrintDocs.cab) with soin.pvk, and soin.spc.
SignCode -v soin.pvk -spc soin.spc ..\Package\soinPrintDocs.cab

rem 8. Since soin.cer is in the soin.ctl, ChkTrust will succeed.
ChkTrust ..\Package\soinPrintDocs.cab 
