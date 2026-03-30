<!---<cfdump var="#form#">
<cf_dump var="#url#">--->

<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 30
		and Mcodigo = 'CG'
</cfquery>
<cfset rsPeriodos = QueryNew("Pvalor")>
<cfset temp = QueryAddRow(rsPeriodos,7)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-3,1)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-2,2)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-1,3)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor+0,4)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor+1,5)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor+2,6)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor+3,7)>

<cfquery name="rsMesCnt" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 40
		and Mcodigo = 'CG'
</cfquery>
<cfset MesCnt = rsMesCnt.Pvalor>

<cfquery name="rsQueryLista" datasource="#session.dsn#">
	Select 
		a.CGCperiodo,
		a.CGCmes,
		a.CGCvalor,		
		a.CGCid,
		b.CGCcodigo,
		b.CGCdescripcion,
		case when b.CGCmodo = 1 then
			'Por Catálogo'
		else
			'Por Clasificación'		
		end as Tipo,
		case when b.CGCmodo = 1 then
			(Select rtrim(ltrim(PCDvalor)) + '-' + rtrim(ltrim(PCDdescripcion))
			from PCDCatalogo pcd
			where pcd.PCDcatid = a.PCDcatid)
		else
			(Select rtrim(ltrim(PCCDvalor)) + '-' + rtrim(ltrim(PCCDdescripcion))
			from PCClasificacionD pcc
			where pcc.PCCDclaid = a.PCCDclaid)
		end as Catalogo,
		case when a.PCDcatid is null then
			a.PCCDclaid
		else
			a.PCDcatid
		end as F_Catalogo,
		b.CGCmodo as HDCGCMODO
		
	from CGParamConductores a
			inner join CGConductores b
				on a.CGCid = b.CGCid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
	<cfif isdefined ("form.filter") and len(trim(form.filter))>
		and a.CGCperiodo = <cfqueryparam value="#form.CGCperiodo#" cfsqltype="cf_sql_integer">
		and a.CGCmes = <cfqueryparam value="#form.CGCmes#" cfsqltype="cf_sql_integer">		
		<cfif isdefined ("form.CGCid") and len(trim(form.CGCid))>
			and  a.CGCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCid#">
		</cfif>
	</cfif>
	Order by b.CGCdescripcion,Tipo,CGCperiodo,CGCmes

</cfquery>  

<cfquery name="rsConductores" datasource="#session.dsn#">
Select CGCid, CGCcodigo, CGCdescripcion, CGCmodo, CGCidc
from CGConductores
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
</cfquery>

<!--- Definición del Modo de la Forma --->
<cfif isdefined("form.CGCperiodo") and isdefined("form.CGCmes")  and (not isdefined ("form.filter"))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfif isdefined("url.CGCmes") and not isdefined("form.CGCmes")>
	<cfset form.CGCmes = url.CGCmes>
</cfif>

<cfif isdefined("url.filter") and not isdefined("form.filter")>
	<cfset form.filter = url.filter>
</cfif>

<cfif isdefined("url.HDCGCmodo") and not isdefined("form.HDCGCmodo")>
	<cfset form.HDCGCmodo = url.HDCGCmodo>
</cfif>

<cfif isdefined ("url.CGCid") and not isdefined ("form.CGCid")>
	<cfset form.CGCid = url.CGCid>
</cfif>


<cfif isdefined("url.Pdescripcion") and not isdefined("form.Pdescripcion")>
	<cfset form.HDCGCmodo = url.HDCGCmodo>
</cfif>

<cfif isdefined("url.F_Catalogo") and not isdefined("form.F_Catalogo")>
	<cfset form.F_Catalogo = url.F_Catalogo>
</cfif>



<!--- Meses --->
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

<!---Form--->
<cfif modo neq "ALTA">

	<!--- Como existe 1 registro por cada periodo mes,
	 pero esta forma esta hecha para modificar todos a la vez,
	 se toma el primero para el control multiusuario.
	--->
	<cfquery name="rsCondValores" datasource="#Session.DSN#" maxrows="1">
		select  CGCperiodo,
				CGCmes,
				CGCid,
				PCCDclaid,
				PCDcatid,
				CGCvalor,
				BMUsucodigo,
				ts_rversion
		from CGParamConductores
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CGCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCid#">
		  and CGCperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCperiodo#">
		  and CGCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGCmes#">
		  <cfif form.HDCGCmodo eq 1>
			  <!--- Catalogo --->
			  and PCDcatid = <cfqueryparam value="#F_Catalogo#" cfsqltype="cf_sql_numeric">
		  <cfelse>
			  <!--- Clasificaciones --->
			  and PCCDclaid = <cfqueryparam value="#F_Catalogo#" cfsqltype="cf_sql_numeric">
		  </cfif>		  
	</cfquery>

</cfif>
<!---JavaScript--->
<script src="/cfmx/sif/js/utilesMonto.js"></script>


<!---Form--->
<cfoutput>

<form action="listaValoresxConductor.cfm" method="post" name="form1">
	<input type="hidden" name="filter" id="filter" value="">
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="3">
		<tr>
			<td colspan="5">
			</td>
		</tr>
		<tr>
			<td><strong>Periodo:</strong></td>
			<td><strong>Mes:</strong></td>
			<td>&nbsp;</td>
		</tr>
		<tr nowrap="nowrap">
			<td valign="top">
				<select name="CGCperiodo" onchange="verifyPeriodoMesAux();">
					<cfloop query="rsPeriodos">
					<option value="#rsPeriodos.Pvalor#"<cfif (modo neq "ALTA" or isdefined ("form.filter")) and rsPeriodos.Pvalor eq form.CGCperiodo> selected<cfelseif modo eq "ALTA" and rsPeriodos.Pvalor eq form.CGCperiodo> selected</cfif>>#rsPeriodos.Pvalor#</option>
					</cfloop>
				</select>			
			</td>
			<td valign="top">
				<select name="CGCmes" onchange="verifyPeriodoMesAux();">
					<cfloop query="rsMeses">
						<option value="#rsMeses.Pvalor#"<cfif (modo neq "ALTA" or isdefined ("form.filter")) and rsMeses.Pvalor eq form.CGCmes> selected<cfelseif modo eq "ALTA" and MesCnt eq rsMeses.Pvalor> selected</cfif>>#Pdescripcion#</option>
					</cfloop>
				</select>
			</td>
		
			<td nowrap="nowrap">
					<cf_botones modo=#modo# sufijo="Valor" include="Filtrar">
			</td>
		</tr>
		
	</table>
	<cfif modo NEQ "ALTA">
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsCondValores.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="CGCid" value="#rsCondValores.CGCid#">
	</cfif>
	<cfif modo eq "CAMBIO">
	
	
		<cfif not isdefined ("form.filter")>
	
			<script language="JavaScript1.2" type="text/javascript">
				document.form1.CGCperiodo.disabled = true;
				document.form1.CGCmes.disabled = true;
				document.form1.cboConductor.disabled = true;
				document.form1.F_PCCDclaid.disabled = true;
				document.form1.F_PCDcatid.disabled = true;
			</script>	
		
		</cfif>
		
	</cfif>
</form>

</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	<!--//
	document.form1.CGCperiodo.description="Período";
	document.form1.CGCmes.description="Mes";	
	
	function deshabilitarValidacion(){
		document.form1.CGCperiodo.required = false;
		document.form1.CGCmes.required = false;
<!---		document.form1.CGCvalor.required = false;
--->	}
	function habilitarValidacion(){
		document.form1.CGCperiodo.required = true;
		document.form1.CGCmes.required = true;
	}
	habilitarValidacion();
	//objForm.AFIindice.obj.focus();

	function funcImportarValor(){
		document.form1.action = 'form_Importar_ValoresxConductor.cfm';
		document.form1.submit();
	}
	
	function funcFiltrarValor(){
		document.form1.filter.value = "yes";
		deshabilitarValidacion();
		return true;
	}
	
	function funcEliminarValor(){
		deshabilitarValidacion();
		return true;
	}

		
	function funcCambioValor(){
		if 	(	(document.form1.CGCperiodo != '') 
			&& 	(document.form1.CGCmes.value != '')
			&&  (document.form1.cboConductor.value))
		{
			document.form1.CGCperiodo.disabled = false;
			document.form1.CGCmes.disabled = false;
			document.form1.cboConductor.disabled = false;
			document.form1.F_PCCDclaid.disabled = false;
			document.form1.F_PCDcatid.disabled = false;				
			return true;
		}
		else
		{
			alert("Erro: Todos los campos son requeridos.");
			return false;
		}
	}
	
	function funcCopiar_ValoresValor()
	{
		var PARAM  = "CGCCopiarValores.cfm?GGCperiodo=#Form.GGCperiodo#&GGCmes=#Form.CGCmes#"
		window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=yes,width=800,height=400')
		return false;
	}

	function funcAltaValor(){
		//Verifica que se eligió Periodo, Mes, Catalogo o Clasificacion, Valor y Conductor
		if 	(	(document.form1.CGCperiodo != '') 
			&& 	(document.form1.CGCmes.value != '')
			&&  (document.form1.cboConductor.value))
		{
			return true;
		}
		else
		{
			alert("Erro: Todos los campos son requeridos.");
			return false;
		}
	}
	
	function MostrarCat(ban){
		var LvarCat = document.getElementById("catCat");	
		var LvarCla = document.getElementById("catCla");
		if (ban == 1) //Por Catálogo
		{
			LvarCat.style.display = "block";
			LvarCla.style.display = "none";
		}
		else//Por Clasificacion
		{
			LvarCat.style.display = "none";
			LvarCla.style.display = "block";
		}
		document.form1.HDCGCmodo.value = ban;
	}
	<cfif isdefined("LvarModo")>
		MostrarCat('<cfoutput>#LvarModo#</cfoutput>');
	</cfif>
	//-->	
</script>

<script>
<!---	var browserType;
	
	if (document.layers) {browserType = "nn4"}
	if (document.all) {browserType = "ie"}
	if (window.navigator.userAgent.toLowerCase().match("gecko")) {
	   browserType= "gecko"
	}--->
	
	<!---function hide() {
	  if (browserType == "gecko" )
		 document.poppedLayer = 
			 eval('document.getElementById("mensaje")');
	  else if (browserType == "ie")
		 document.poppedLayer = 
			eval('document.getElementById("mensaje")');
	  else
		 document.poppedLayer =   
			eval('document.layers["mensaje"]');
	  document.poppedLayer.style.visibility = "hidden";
	}
	--->
	<!---function show() {
	  if (browserType == "gecko" )
		 document.poppedLayer = 
			 eval('document.getElementById("mensaje")');
	  else if (browserType == "ie")
		 document.poppedLayer = 
			eval('document.getElementById("mensaje")');
	  else
		 document.poppedLayer = 
			 eval('document.layers["mensaje"]');
	  document.poppedLayer.style.visibility = "visible";
	}
--->
	function verifyPeriodoMesAux(){
		if ((document.form1.CGCperiodo.value < <cfoutput>#rsPeriodo.Pvalor#</cfoutput>) || (document.form1.CGCmes.value < <cfoutput>#MesCnt#</cfoutput>)){
			<cfif modo EQ "ALTA">
			document.form1.AltaValor.disabled=true;
			document.form1.AltaValor.style.visibility='hidden';
			<cfelseif modo EQ "CAMBIO">
			document.form1.CambioValor.disabled=true;
			document.form1.CambioValor.style.visibility='hidden';
			document.form1.BajaValor.disabled=true;
			document.form1.BajaValor.style.visibility='hidden';
			</cfif>
			
		}
		else {
			<cfif modo EQ "ALTA">
			document.form1.AltaValor.disabled=false;
			document.form1.AltaValor.style.visibility='visible';
			<cfelseif modo EQ "CAMBIO">
			document.form1.CambioValor.disabled=false;
			document.form1.CambioValor.style.visibility='visible';
			document.form1.BajaValor.disabled=false;
			document.form1.BajaValor.style.visibility='visible';
			</cfif>
		<!---	hide();--->
		}
	}
	verifyPeriodoMesAux();
</script>








<!---<cfdump var="#form#">
<cf_dump var="#url#">--->


<!---<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 30
		and Mcodigo = 'CG'
</cfquery>

<cfset rsPeriodos = QueryNew("Pvalor")>
<cfset temp = QueryAddRow(rsPeriodos,7)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-3,1)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-2,2)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-1,3)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor+0,4)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor+1,5)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor+2,6)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor+3,7)>

<cfquery name="rsMesCnt" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 40
		and Mcodigo = 'CG'
</cfquery>
<cfset MesCnt = rsMesCnt.Pvalor>

<!--- Definición del Modo de la Forma --->
<cfif isdefined("form.CGCperiodo") and isdefined("form.CGCmes")  and (not isdefined ("form.filter"))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<!--- Meses --->
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>


<cfoutput>
<form action="listaValoresxConductor.cfm" method="post" name="form1">
	<input type="hidden" name="filter" id="filter" value="">
		<table align="center" width="100%" cellpadding="2" cellspacing="0">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="right" width="45%">&nbsp;</td></tr>
			<tr>
				<td width="10%" align="right"><strong>Periodo:</strong>&nbsp;</td>
				<td width="70%" >
					<select name="CGCperiodo" onChange="verifyPeriodoMesAux();">
						<cfloop query="rsPeriodos">
							<option value="#rsPeriodos.Pvalor#"<cfif (modo neq "ALTA" or isdefined ("form.filter")) and rsPeriodos.Pvalor eq form.CGCperiodo> selected<cfelseif modo eq "ALTA" and rsPeriodos.Pvalor eq form.CGCperiodo> selected</cfif>>#rsPeriodos.Pvalor#</option>
						</cfloop>
					</select>			
				</td>
			</tr>
			<tr>
				<td width="10%" align="right"><strong>Mes:</strong>&nbsp;</td>
				<td width="70%" >
					<select name="CGCmes" onChange="verifyPeriodoMesAux();">
						<cfloop query="rsMeses">
							<option value="#rsMeses.Pvalor#"<cfif (modo neq "ALTA" or isdefined ("form.filter")) and rsMeses.Pvalor eq form.CGCmes> selected<cfelseif modo eq "ALTA" and MesCnt eq rsMeses.Pvalor> selected</cfif>>#Pdescripcion#</option>
						</cfloop>
					</select>
				</td>
			</tr>
				<td colspan="7">
					<cf_botones values="Filtrar" tabindex="1">
				</td>
			<tr><td>&nbsp;</td></tr>
	</table>
	</form>	
	</cfoutput>

--->