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

<cfif isdefined("url.F_Catalogo") and not isdefined("form.F_Catalogo")>
	<cfset form.F_Catalogo = url.F_Catalogo>
</cfif>

<cfif isdefined("url.CGCvalor") and not isdefined("form.CGCvalor")>
	<cfset form.CGCvalor = url.CGCvalor>
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

<form action="SQLValoresxConductor.cfm" method="post" name="form1">
	<input type="hidden" name="filter" id="filter" value="">
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="3" bgcolor="DDDDDD">
		<tr>
			<td>
	
		<tr>
			<td><strong>Conductor:</strong></td>
			<td>&nbsp;<font color="##FF0000">*</font><strong>UENS:</strong><br></td>
			<td><strong>Periodo:</strong></td>
			<td><strong>Mes:</strong></td>
			<td><font color="##FF0000">*</font><strong>Valor:</strong></td>
			<td>&nbsp;</td>
		</tr>
		<tr nowrap="nowrap">
		<td valign="top"><select name="cboConductor">
							<cfloop query="rsConductores">
								<option onclick="javascript:MostrarCat('#rsConductores.CGCmodo#')" value="<cfoutput>#rsConductores.CGCid#</cfoutput>"
								<cfif (MODO neq 'ALTA' or isdefined("form.filter")) 
									and isdefined("form.CGCid")
									and form.CGCid eq rsConductores.CGCid>selected</cfif>>
									<cfoutput>#trim(rsConductores.CGCcodigo)#-#trim(rsConductores.CGCdescripcion)#</cfoutput>
								</option>
							</cfloop>
							</select>
							
							<cfif isdefined("form.CGCid")>

								<cfquery name="rsModoConductor" datasource="#session.dsn#">
								Select CGCmodo, CGCidc
								from CGConductores
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
								  and CGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGCid#">
								</cfquery>								
								
								<cfset LvarModo = rsModoConductor.CGCmodo>
								<cfset LvarCatid = rsModoConductor.CGCidc>								

							<cfelse>
								<cfset LvarModo = rsConductores.CGCmodo>	
								<cfset LvarCatid = rsConductores.CGCidc>														
							</cfif></td>
							
							<td valign="top">
							<div id="catCla" style="display:none">
												
						<cfquery name="rsF_PCCDclaid" datasource="#Session.DSN#">
							select  PCCEclaid as F_PCCEclaid,
									PCCDclaid as F_PCCDclaid,
									PCCDvalor as F_PCDcodigo,
									PCCDdescripcion as F_PCDdescripcion									
							from PCClasificacionD
							where PCCEclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCatid#">
						</cfquery>
						
						<select name="F_PCCDclaid">
						<cfloop query="rsF_PCCDclaid">
							<option value="<cfoutput>#rsF_PCCDclaid.F_PCCDclaid#</cfoutput>" <cfif modo NEQ "ALTA" and rsF_PCCDclaid.F_PCCDclaid eq form.F_Catalogo and form.HDCGCmodo eq 2>selected</cfif>><cfoutput>#rsF_PCCDclaid.F_PCDcodigo#-#rsF_PCCDclaid.F_PCDdescripcion#</cfoutput></option>
						</cfloop>
						</select>						
						</div>
							
							</td>
							
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
			<td valign="top">
				
				<input	type		= "text"
					name		= "CGCvalor" id="CGCvalor"
					value		= "<cfif modo neq 'ALTA' and not isdefined ("form.filter")>#rsCondValores.CGCvalor#</cfif>"
					style		= "text-align:right;"
					tabindex	= "-1"
					onfocus		= "this.value=qf(this); this.select();"
					onkeypress	= "return _CFinputText_onKeyPress(this,event,14,2,false,true);"
					onkeyup		= "_CFinputText_onKeyUp(this,event,14,2,false,true);"
					onblur		= "fm(this,2,false,false,'0'); if (window.funcPRCmontoloctot) window.funcPRCmontoloctot();"
					size		= "14"
					maxlength	= "10"
				>			
			
			</td>
			
		</tr>
		<tr>
		<td colspan="7">
					<cf_botones modo=#modo# sufijo="Valor" include="Importar,Filtrar,Copiar_Valores">
			</td>
		</tr>
		<tr>
			<td colspan="4" align="center">
				<div id="mensaje" style="visibility: visible">
				<font color="red">(*) Este Valor no es Modificable, pertenece a un Periodo-Mes anterior al Periodo-Mes Contable actual.</font>
				<layer></layer></div>
			</td>
		</tr>
		<tr>
			<td colspan="3">
			
				<table align="center" width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td rowspan="2" valign="middle">
					
						<!--- CATALOGOS--->
						<div id="catCat" style="display:block">
						<font color="##FF0000">*</font><strong>Catálogo:</strong><br>
						<cfif isdefined("form.F_Catalogo") and form.F_Catalogo NEQ '' and form.HDCGCmodo eq 1>
							<cfquery name="rsF_PCDcatid" datasource="#Session.DSN#">
								select  PCEcatid as F_PCEcatid,
										PCDcatid as F_PCDcatid,
										PCDvalor as F_PCDcodigo,
										PCDdescripcion as F_PCDdescripcion
								from PCDCatalogo
								where Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ecodigo#">
									and PCDcatid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCatid#">									
							</cfquery>
							
							<cf_sifcatalogos name="F_PCDcatid" frame="filtroFrame" llave="#Form.F_Catalogo#" codigo="F_PCDcodigo" desc="F_PCDdescripcion" query="#rsF_PCDcatid#" form="form1" Conexion="#Session.DSN#" tabindex="2">
						<cfelse>					
							<cf_sifcatalogos name="F_PCDcatid" frame="filtroFrame" codigo="F_PCDcodigo" desc="F_PCDdescripcion" form="form1" Conexion="#Session.DSN#" tabindex="2">
						</cfif>
						</div>
						
						<!--- CLASIFICACIONES--->
						<div id="catCla" style="display:none">
						<font color="##FF0000">*</font><strong>UENS:</strong><br>						
						<cfquery name="rsF_PCCDclaid" datasource="#Session.DSN#">
							select  PCCEclaid as F_PCCEclaid,
									PCCDclaid as F_PCCDclaid,
									PCCDvalor as F_PCDcodigo,
									PCCDdescripcion as F_PCDdescripcion									
							from PCClasificacionD
							where PCCEclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCatid#">
						</cfquery>
						
						<select name="F_PCCDclaid">
						<cfloop query="rsF_PCCDclaid">
							<option value="<cfoutput>#rsF_PCCDclaid.F_PCCDclaid#</cfoutput>" <cfif modo NEQ "ALTA" and rsF_PCCDclaid.F_PCCDclaid eq form.F_Catalogo and form.HDCGCmodo eq 2>selected</cfif>><cfoutput>#rsF_PCCDclaid.F_PCDcodigo#-#rsF_PCCDclaid.F_PCDdescripcion#</cfoutput></option>
						</cfloop>
						</select>						
						</div>
					</td>
				</tr>				
				</table>
				
				
			</td>
			<td>&nbsp;</td>
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
	<input type="hidden" name="HDCGCmodo" value="#LvarModo#">
</form>

</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	<!--//
	document.form1.CGCperiodo.description="Período";
	document.form1.CGCmes.description="Mes";	
	document.form1.CGCvalor.description="Valor";
	
	function deshabilitarValidacion(){
		document.form1.CGCperiodo.required = false;
		document.form1.CGCmes.required = false;
		document.form1.CGCvalor.required = false;
	}
	function habilitarValidacion(){
		document.form1.CGCperiodo.required = true;
		document.form1.CGCmes.required = true;
		document.form1.CGCvalor.required = true;
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

	function funcBajaValor(){
		document.form1.CGCperiodo.disabled = false;
		document.form1.CGCmes.disabled = false;	
		document.form1.cboConductor.disabled = false;
		document.form1.F_PCCDclaid.disabled = false;
		document.form1.F_PCDcatid.disabled = false;		
	}
	
	function funcNuevoValor(){
		document.form1.CGCperiodo.disabled = false;
		document.form1.CGCmes.disabled = false;	
		document.form1.cboConductor.disabled = false;
		document.form1.F_PCCDclaid.disabled = false;
		document.form1.F_PCDcatid.disabled = false;		
	}
	
	
	function funcCambioValor(){
		if 	(	(document.form1.CGCperiodo != '') 
			&& 	(document.form1.CGCmes.value != '')
			&&  (document.form1.CGCvalor.value)
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
			&&  (document.form1.CGCvalor.value)
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
	var browserType;
	
	if (document.layers) {browserType = "nn4"}
	if (document.all) {browserType = "ie"}
	if (window.navigator.userAgent.toLowerCase().match("gecko")) {
	   browserType= "gecko"
	}
	
	function hide() {
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
	
	function show() {
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

	function verifyPeriodoMesAux(){
		if ((document.form1.CGCperiodo.value < <cfoutput>#rsPeriodo.Pvalor#</cfoutput>) || (document.form1.CGCmes.value < <cfoutput>#MesCnt#</cfoutput>)){
			<cfif modo EQ "ALTA">
			document.form1.AltaValor.disabled=true;
			document.form1.AltaValor.style.visibility='hidden';
			document.form1.CGCvalor.disabled=true;
			<cfelseif modo EQ "CAMBIO">
			document.form1.CGCvalor.disabled=true;
			document.form1.CambioValor.disabled=true;
			document.form1.CambioValor.style.visibility='hidden';
			document.form1.BajaValor.disabled=true;
			document.form1.BajaValor.style.visibility='hidden';
			</cfif>
			show();
		}
		else {
			<cfif modo EQ "ALTA">
			document.form1.AltaValor.disabled=false;
			document.form1.AltaValor.style.visibility='visible';
			document.form1.CGCvalor.disabled=false;
			<cfelseif modo EQ "CAMBIO">
			document.form1.CGCvalor.disabled=false;
			document.form1.CambioValor.disabled=false;
			document.form1.CambioValor.style.visibility='visible';
			document.form1.BajaValor.disabled=false;
			document.form1.BajaValor.style.visibility='visible';
			</cfif>
			hide();
		}
	}
	verifyPeriodoMesAux();
</script>
