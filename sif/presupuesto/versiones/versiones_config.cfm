<cfscript>
	//Pasa valores del url al form
	if (isdefined("url.cvid") and len(url.cvid) and (not isdefined("form.cvid") or (isdefined("form.cvid") and len(form.cvid) eq 0))) form.cvid = url.cvid;
	if (isdefined("url.btnnuevo") and len(url.btnnuevo) and (not isdefined("form.btnnuevo") or (isdefined("form.btnnuevo") and len(form.btnnuevo) eq 0))) form.btnnuevo = url.btnnuevo;
	if (isdefined("url.cpresup") and len(url.cpresup) and (not isdefined("form.cpresup") or (isdefined("form.cpresup") and len(form.cpresup) eq 0))) form.cpresup = url.cpresup;
	if (isdefined("url.cmayor") and len(url.cmayor) and (not isdefined("form.cmayor") or (isdefined("form.cmayor") and len(form.cmayor) eq 0))) form.cmayor = url.cmayor;
	if (isdefined("url.cvpcuenta") and len(url.cvpcuenta) and (not isdefined("form.cvpcuenta") or (isdefined("form.cvpcuenta") and len(form.cvpcuenta) eq 0))) form.cvpcuenta = url.cvpcuenta;
	if (isdefined("url.cpcano") and len(url.cpcano) and (not isdefined("form.cpcano") or (isdefined("form.cpcano") and len(form.cpcano) eq 0))) form.cpcano = url.cpcano;
	if (isdefined("url.cpcmes") and len(url.cpcmes) and (not isdefined("form.cpcmes") or (isdefined("form.cpcmes") and len(form.cpcmes) eq 0))) form.cpcmes = url.cpcmes;
	if (isdefined("url.ocodigo") and len(url.ocodigo) and (not isdefined("form.ocodigo") or (isdefined("form.ocodigo") and len(form.ocodigo) eq 0))) form.ocodigo = url.ocodigo;
	if (isdefined("url.mcodigo") and len(url.mcodigo) and (not isdefined("form.mcodigo") or (isdefined("form.mcodigo") and len(form.mcodigo) eq 0))) form.mcodigo = url.mcodigo;
	if (isdefined("url.btnMonedas") and len(url.btnMonedas) and (not isdefined("form.btnMonedas") or (isdefined("form.btnMonedas") and len(form.btnMonedas) eq 0))) form.btnMonedas = url.btnMonedas;
	//Define que pantalla pintar en la parte inferior
	pantalla = 0;
	if (isdefined("form.btnnuevo"))
	{
		pantalla = 1;
		form.cvid = "";
	}
	else
	{
		if ((isdefined("form.cvid")     and len(form.cvid)      and form.cvid gt 0))  pantalla = 1;
		if (isdefined("form.cpresup")   and len(form.cpresup)   and form.cpresup gt 0) pantalla = 2;
		if (isdefined("form.cpresup")   and len(form.cpresup)   and form.cpresup eq -100) pantalla = 20;
		if (isdefined("form.cvpcuenta") and len(form.cvpcuenta) and form.cvpcuenta gt 0) pantalla = 3;	
		if (isdefined("form.ocodigo")   and len(form.ocodigo)   and form.ocodigo gt -1 and isdefined("form.btnMonedas")) pantalla = 4;
		if (isdefined("form.cpcano")   and len(form.cpcano)   and form.cpcano gt -1 and isdefined("form.cpcmes") and form.cpcmes gt -1 ) pantalla = 5;
	}
</cfscript>
