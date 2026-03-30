<!---Esta pantalla recibe parámetros de llaves tanto por post como por get--->
<cfscript>
	//maneja la existencia de un error al inicio de la pantalla
	error = "";
	// Solo un comprador debería utilizar este proceso
	if (error eq "")
	{
		if (isdefined("Session.Compras.Comprador"))	form.comprador = session.compras.comprador; 
		else error = "El usuario actial no está definido como comprador.";
	}
	if (error eq "")
	{
		// Pasa parámetros que están en la variable url a form, para manejarlas todas ahí
		if (isdefined("url.cmpid")) form.cmpid = url.cmpid; //Proceso de Compra
		if (isdefined("url.ecid")) form.ecid = url.ecid; //Proceso de Compra
		if (isdefined("url.opt")) form.opt = url.opt; //Proceso de Compra
		// Pasa chk al cmpid
		if (isdefined("form.chk")) form.cmpid = form.chk; //Proceso de Compra
	}
	if (error eq "")
	{
		/* Define la pantalla que se va a presentar
			Pantallas Discponibles:
				0: Lista de Procesos de Compra Publicados (estado = 10), contiene la cantidad de cotizaciones realizadas por los proveedores.
				1: Lista de Cotizaciones de Un Proceso de Compra.
				2: Vista de una Cotización de un Proceso de Compra.
		*/
		form.pantalla = 0;
		if (isdefined("form.opt") and len(trim(form.opt))) form.pantalla = form.opt;
	}
</cfscript>
<cfif Len(error)><cf_errorCode	code = "50299"
                 				msg  = " @errorDat_1@ Acceso Denegado!"
                 				errorDat_1="#error#"
                 ></cfif>

