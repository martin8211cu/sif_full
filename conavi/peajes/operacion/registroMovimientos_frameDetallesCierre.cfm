<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
<cfparam name="form.modoD" default="ALTA">

<cfif modo neq 'ALTA' and isdefined('url.PDTCid') and len(trim(url.PDTCid))>
	<cfset form.PDTCid = #url.PDTCid#>
</cfif>
<cfquery name="rsSelectCarriles" datasource="#session.dsn#">
	select Pcarriles
	from Peaje 
	where Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.selectPeaje#"> and  Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsSelectCarrilesCerrados" datasource="#session.dsn#">
	select PDTCid,
	case when (PDTChoraini/60) < 10 then '0' #_Cat# <cf_dbfunction name="to_char" args="PDTChoraini/60"> else <cf_dbfunction name="to_char" args="PDTChoraini/60"> end
		#_Cat#':'#_Cat#
		case when PDTChoraini -(PDTChoraini/60)*60 < 10 then '0' #_Cat# <cf_dbfunction name="to_char" args="PDTChoraini -(PDTChoraini/60)*60"> else <cf_dbfunction name="to_char" args="PDTChoraini -(PDTChoraini/60)*60"> end
	as PDTChoraini,
		case when (PDThorafin/60) < 10 then '0' #_Cat# <cf_dbfunction name="to_char" args="PDThorafin/60"> else <cf_dbfunction name="to_char" args="PDThorafin/60"> end
		#_Cat#':'#_Cat#
		case when PDThorafin -(PDThorafin/60)*60 < 10 then '0' #_Cat# <cf_dbfunction name="to_char" args="PDThorafin -(PDThorafin/60)*60"> else <cf_dbfunction name="to_char" args="PDThorafin -(PDThorafin/60)*60"> end
	as PDThorafin,
	PDTCcarril,
	<cf_dbfunction name="sPart" args="PDTCcomentario,1,20"> as PDTCcomentario 
	from PDTCerrado
	where PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PETid#">
	<cfif isdefined('form.filtro_PDTCcarril') and len(trim(form.filtro_PDTCcarril))>
	and PDTCcarril = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.filtro_PDTCcarril#">
	</cfif>
	<cfif isdefined('form.filtro_PDTCcomentario') and len(trim(form.filtro_PDTCcomentario))>
	and PDTCcomentario like '%#form.filtro_PDTCcomentario#%'
	</cfif>
	order by PDTCcarril
</cfquery>

<cfif modo neq 'ALTA' and isdefined('form.PDTCid') and len(trim(form.PDTCid))>
	<cfquery name="rsSelectDatosCarrilCerrado" datasource="#session.dsn#">
		select PDTCid, PDTCcarril, PDTChoraini, PDThorafin, PDTCcomentario, ts_rversion
		from PDTCerrado
		where PDTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PDTCid#">
		order by PDTCid
	</cfquery>
	<cfset PDTCcarril=rsSelectDatosCarrilCerrado.PDTCcarril>
	<cfset PDTChoraini=rsSelectDatosCarrilCerrado.PDTChoraini>
	<cfset PDThorafin=rsSelectDatosCarrilCerrado.PDThorafin>
	<cfset PDTCcomentario=rsSelectDatosCarrilCerrado.PDTCcomentario>
	<cfset modoD='CAMBIO'>
<cfelse>
	<cfset PDTCcarril="0">
	<cfset PDTChoraini="0">
	<cfset PDThorafin="0">
	<cfset PDTCcomentario="">
	<cfset modoD='ALTA'>
</cfif>
<cfoutput>
<table border="0" width="100%"><tr>
	<td width="60%" valign="top">
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
			query="#rsSelectCarrilesCerrados#" 
			conexion="#session.dsn#"
			desplegar="PDTCcarril, PDTChoraini, PDThorafin,PDTCcomentario"
			etiquetas="Carril , Hora Inicio, Hora Final,Comentario"
			formatos="S,S,S,S"
			mostrar_filtro="true"
			align="left,left,left,left"
			checkboxes="n"
			ira="registroMovimientos.cfm?PETid=#form.PETid#&tab=2"
			keys="PDTCid"
			formName="listaCierre">
		</cfinvoke>
	</td>
	<td width="40%">
		<cfform action="registroMovimientos_SQL.cfm" method="post" name="formCierre">
		<table border="0" width="100%">
			<tr>	
				<td width="10%"> Carril N&deg;:</td>
				<td width="90%">
					<select name="selectCarril" id="selectCarril">
						<option value="" selected="selected">Seleccione Carill</option>
						<cfloop from="1" to="#rsSelectCarriles.Pcarriles#" index="i">
							<option value="#i#" #iif(i eq PDTCcarril ,'selected=''selected''','')#>#i#</option>
						</cfloop>
						<cfif modoD eq 'ALTA' >
							<option value="all">Todos</option>
						</cfif>
					</select>
				</td>
			</tr>
			<tr>	
				<td> Hora desde:</td>
				<td>
					<cf_hora name="horaDesde" form="formCierre" value="#PDTChoraini#">
				</td>
			</tr>
			
			<tr>	
				<td> Hora hasta:</td>
				<td>
					<cf_hora name="horaHasta" form="formCierre" value="#PDThorafin#">
				</td>
			</tr>
			<tr>	
				<td valign="top"> Comentario:</td>
				<td height="15"> 
					<textarea name="comentario" cols="50" wrap="physical" id="comentario" onkeypress="if(this.value.length &gt;= 120){ alert('Has superado el tamaño máximo permitido 120 caracteres'); return false; }" height="15">#PDTCcomentario#</textarea>   
				</td>
			</tr>
			<tr>	
				<td colspan="2">
				<cfif modo neq 'ALTA' and isdefined('form.PDTCid') and len(trim(form.PDTCid))>
					<cf_botones modo="CAMBIO" names="CAMBIOCIERRE,BAJACIERRE, NUEVOCIERRE">
				<cfelse>
					<cf_botones modo="ALTA" names="ALTACIERRE,LIMPIARCIERRE">
				</cfif>
				</td>
			</tr>
			<tr>	
				<td colspan="2">
					<input type="hidden" id="Ecodigo" name="Ecodigo" value="#session.Ecodigo#" />
					<input type="hidden" id="MBUsucodigo" name="MBUsucodigo" value="#session.usucodigo#" />
					<input type="hidden" name="PETid" value="#form.PETid#">
					<input type="hidden" id="selectTurno" name="selectTurno" value="#form.selectTurno#" />
					<cfif modo neq 'ALTA' and isdefined('form.PDTCid') and len(trim(form.PDTCid))>
						<cfset ts = "">
						<input type="hidden" name="PDTCid" value="#form.PDTCid#">
						<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsSelectDatosCarrilCerrado.ts_rversion#" returnvariable="ts">
						</cfinvoke>
						<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
					</cfif>
					
				</td>
			</tr>
		</table>
		</cfform>
	</td>
</tr></table>
<cf_qforms form='formCierre' objForm="objformCierre">
<script language="javascript1.2" type="text/javascript">

	objformCierre.selectCarril.description = "#JSStringFormat('Carril')#";
	objformCierre.horaDesde.description = "#JSStringFormat('Hora Desde')#";
	objformCierre.horaHasta.description = "#JSStringFormat('Hora Hasta')#";
	objformCierre.selectCarril.required= true;
	objformCierre.horaDesde.required= true;
	objformCierre.horaHasta.required = true;
	
	function funcNUEVOCIERRE(){
		location.href="registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&tab=2";
		return false;
	}
	function filtrar_Plista(){ 
		document.listaCierre.action='registroMovimientos.cfm?modo=CAMBIO&PETid=#form.PETid#&tab=2'; 
		if (window.funcFiltrar) { 
			if (funcFiltrar()) { return true; } }
			else { return true; }
		 return false; 
	}
	listaCierre.filtro_PDTChoraini.style.visibility = 'hidden';
	listaCierre.filtro_PDThorafin.style.visibility = 'hidden';
</script>
</cfoutput>