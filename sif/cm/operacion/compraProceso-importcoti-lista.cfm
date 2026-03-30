<cfif isdefined("Session.Compras.ProcesoCompra.CMPid") and not isdefined("form.CMPid")>
	<cfset form.CMPid = Session.Compras.ProcesoCompra.CMPid>
</cfif>
<cfif isdefined("Session.Compras.ProcesoCompra.CMPid") and isdefined("form.CMPid") and Len(Trim(form.CMPid)) EQ 0>
	<cfset form.CMPid = Session.Compras.ProcesoCompra.CMPid>
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfparam name="lvarSolicitante" default="true">
<cfquery name="qryLista" datasource="#session.dsn#">
	select <cfif isdefined("Session.Compras.ProcesoCompra.CMPid") and not isdefined("form.CMPid")>6<cfelse>2</cfif> as opt, a.ECid, a.CMPid, a.Ecodigo, a.SNcodigo, 
		a.CMCid, a.Mcodigo, a.ECtipocambio, a.ECconsecutivo, 
		a.ECnumero, a.ECnumprov, a.ECdescprov, a.ECobsprov, 
		a.ECprocesado, a.ECsubtotal, a.ECtotdesc, a.ECtotimp, 
		a.ECtotal, a.ECfechacot, a.ECestado, a.Usucodigo, 
		a.fechaalta, a.CPid, 
		<cfif not lvarSolicitante>'Proveedor: ' #_Cat# b.SNnumero #_Cat# ' - ' #_Cat# b.SNnombre #_Cat# ' / ' #_Cat# </cfif>  'Comprador: ' #_Cat# c.CMCcodigo #_Cat# ' - ' #_Cat# c.CMCnombre as ProveedorYComprador
	from ECotizacionesCM a
		inner join SNegocios b
			on b.SNcodigo = a.SNcodigo
			and b.Ecodigo = a.Ecodigo
		inner join CMCompradores c
			on c.CMCid = a.CMCid
			and c.Ecodigo = a.Ecodigo
	where a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMPid#">
		and a.ECestado in (5,10)
    order by ProveedorYComprador, ECfechacot 
</cfquery>
<cfset LImportar = "">
<cfif not lvarSolicitante>
	<cfset LImportar = "Importar,">
</cfif>
<cfif isdefined("Regresar")><cfset LRegresar="Regresar"><cfelse><cfset LRegresar=""></cfif>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="qryLista">
 	<cfinvokeargument name="query" value="#qryLista#"/>
	<cfinvokeargument name="cortes" value="ProveedorYComprador"/>
	<cfinvokeargument name="desplegar" value="ECnumprov, ECdescprov, ECprocesado, ECfechacot, ECtotal"/>
	<cfinvokeargument name="etiquetas" value="Número, Descripción, Capturado por, Fecha, Total"/>
	<cfinvokeargument name="formatos" value="V,S,S,D,M"/>
	<cfinvokeargument name="align" value="left,left,left,center,right"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="botones" value="#LImportar##LRegresar#"/>
	<cfinvokeargument name="funcion" value="doConlis"/>
	<cfinvokeargument name="fparams" value="ECid"/>
	<cfinvokeargument name="maxrows" value="20"/>
	<cfinvokeargument name="pageIndex" value="99"/>
</cfinvoke>
<br>

<script language='JavaScript' type='text/JavaScript' src='/cfmx/sif/js/qForms/qforms.js'></script>
<script language='javascript' type='text/JavaScript' >
<!--//
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis(ECid) {
		var params ="";
		<cfoutput>
		popUpWindow("/cfmx/sif/cm/operacion/compraProceso-importcoti-vista<cfif lvarSolicitante>-SOL</cfif>.cfm?CMPid=#form.CMPid#&ECid="+ECid,10,10,950,650);
		</cfoutput>
	}

	<cfif isdefined("Regresar")>
		function funcRegresar(){
			location.href = "<cfoutput>#Regresar#</cfoutput>";
			return false;
		}
	</cfif>
//-->
</script>