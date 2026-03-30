<!---

aqui no se requiere un cfapplication
	porque el logout.cfm ya lo tiene, y asi tambien
	no interfiere con el login-check.cfm y el login-form.cfm

cfapplication name="SIF_ASP" 
sessionmanagement="Yes"
clientmanagement="Yes"
setclientcookies="Yes"
sessiontimeout=#CreateTimeSpan(0,10,0,0)# 
--->
<cfinclude template="/sif/Utiles/SIFfunciones.cfm">
