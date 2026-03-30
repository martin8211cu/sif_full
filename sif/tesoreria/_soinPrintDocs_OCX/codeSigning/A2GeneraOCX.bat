rem 7. Sign something (soinPrintDocs.ocx) with soin.pvk, and soin.spc.
SignCode -v soin.pvk -spc soin.spc ..\soinPrintDocs.ocx

rem 8. Since soin.cer is in the soin.ctl, ChkTrust will succeed.
ChkTrust ..\soinPrintDocs.ocx 

pause