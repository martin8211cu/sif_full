<cfif isdefined("url.FechaIni") and not isdefined("form.FechaIni")>
	<cfset form.FechaIni = url.FechaIni>
</cfif>

<cfif isdefined("url.FechaFin") and not isdefined("form.FechaFin")>
	<cfset form.FechaFin = url.FechaFin>
</cfif>

<cfif isdefined("url.FechaVenIni") and not isdefined("form.FechaVenIni")>
	<cfset form.FechaVenIni = url.FechaVenIni>
</cfif>

<cfif isdefined("url.FechaVenFin") and not isdefined("form.FechaVenFin")>
	<cfset form.FechaVenFin = url.FechaVenFin>
</cfif>

<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>

<cfif isdefined("url.CCTcodigo") and not isdefined("form.CCTcodigo")>
	<cfset form.CCTcodigo = url.CCTcodigo>
</cfif>

<cfif isdefined("url.DocumentoSaldo") and not isdefined("form.DocumentoSaldo")>
	<cfset form.DocumentoSaldo= url.DocumentoSaldo>
</cfif>
<cfif isdefined("url.Documento") and not isdefined("form.Documento")>
	<cfset form.Documento= url.Documento>
</cfif>

<cfif isdefined("url.TipoItem") and not isdefined("form.TipoItem")>
	<cfset form.TipoItem= url.TipoItem>
</cfif>


<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript" src="../../js/fechas.js"></script>
<!---Consultas para pintar el formulario--->
<!---Categorias--->
<cfquery name="rsCCTransacciones" datasource="#Session.DSN#">
	 select CCTcodigo, CCTdescripcion 
	 from CCTransacciones 
	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 		<!--- and CCTtipo = 'D' --->
		and CCTpago = 0
</cfquery>
<cfif isdefined('form.SNcodigo') and LEN(TRIM(form.SNcodigo))>
	<cfquery name="rsSocio" datasource="#session.DSN#">
		select *
		from SNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
	</cfquery>
</cfif>
<cfset LB_Socio = t.Translate('LB_Socio','Socio')>
<cfset LB_FechaDoctoDesde = t.Translate('LB_FechaDoctoDesde','Fecha Documento desde')>
<cfset LB_FechaDoctoHasta = t.Translate('LB_FechaDoctoHasta','Fecha Documento hasta')>
<cfset LB_FechaVencDesde  = t.Translate('LB_FechaVencDesde','Fecha Vencimiento desde')>
<cfset LB_FechaVencHasta  = t.Translate('LB_FechaDoctoHasta','Fecha Vencimiento hasta')>
<cfset LB_TipoTrans  = t.Translate('LB_TipoTrans','Tipo de Transacci&oacute;n')>
<cfset LB_TipoItem = t.Translate('LB_TipoItem','Tipo de Item')>
<cfset LB_Articulo = t.Translate('LB_Articulo','Art&iacute;culo')>
<cfset LB_Servicio = t.Translate('LB_Servicio','Servicio')>
<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Timbre = t.Translate('LB_Timbre','Timbre')>
<cfset LB_TimbreS = t.Translate('LB_TimbreS','Sin Timbre Fiscal')>
<cfset LB_TimbreC = t.Translate('LB_TimbreC','Con Timbre Fiscal')>
<cfset LB_TimbreA = t.Translate('LB_TimbreA','Todos')>
<form name="form1" method="get" action="RFacturasCC2-reporte.cfm">
	<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
    	<cfoutput>
		<tr>
			<td align="right"><strong>#LB_Socio#:</strong> </td>
			<td align="left">
				<cfif isdefined('form.SNcodigo') and LEN(TRIM(form.SNcodigo))>
					<cf_sifsociosnegocios2 SNcodigo="SNcodigo" SNnombre="SNnombre" SNtiposocio="C" SNnumero="SNnumero" idquery="#rsSocio.SNcodigo#">
				<cfelse>
					<cf_sifsociosnegocios2 SNcodigo="SNcodigo" SNnombre="SNnombre" SNtiposocio="C" SNnumero="SNnumero">
				</cfif>
			</td>
		</tr>  
		<tr>
			<td align="right"><strong>#LB_FechaDoctoDesde#:</strong></td>
			<td>
				<cfif isdefined('form.fechaIni') and LEN(TRIM(form.fechaIni))>
					<cf_sifcalendario name="fechaIni" value="#form.fechaIni#" tabindex="1">
				<cfelse>
					<cfset LvarFecha = createdate(year(now()),month(now()),1)>
					<cf_sifcalendario form="form1" value="#DateFormat(LvarFecha, 'dd/mm/yyyy')#" name="fechaIni" tabindex="1"> 
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_FechaDoctoHasta#:</strong></td>    
			<td>
				<cfif isdefined('form.fechaFin') and LEN(TRIM(form.fechaFin))>
					<cf_sifcalendario name="fechaFin" value="#form.fechaFin#" tabindex="1">
				<cfelse>
					<cf_sifcalendario form="form1" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="fechaFin" tabindex="1"> 
				</cfif>
			</td>
		</tr>
        <tr>
			<td align="right"><strong>#LB_FechaVencDesde#:</strong></td>
			<td>
				<cfif isdefined('form.fechaVenIni') and LEN(TRIM(form.fechaVenIni))>
					<cf_sifcalendario name="fechaVenIni" value="#form.fechaVenIni#" tabindex="1">
				<cfelse>
					<cfset LvarFechaVen = createdate(year(now()),month(now()),1)>
					<cf_sifcalendario form="form1" value="#DateFormat(LvarFechaVen, 'dd/mm/yyyy')#" name="fechaVenIni" tabindex="1"> 
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_FechaVencHasta#:</strong></td>
			<td>
				<cfif isdefined('form.fechaVenFin') and LEN(TRIM(form.fechaVenFin))>
					<cf_sifcalendario name="fechaVenFin" value="#form.fechaVenFin#" tabindex="1">
				<cfelse>
					<cf_sifcalendario form="form1" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="fechaVenFin" tabindex="1"> 
				</cfif>
			</td>
		</tr>
        </cfoutput>
		<tr>
			<td align="right"><strong><cfoutput>#LB_TipoTrans#: </cfoutput></strong></td>
			<td>
				<cfoutput>
					<select name="CCTcodigo" tabindex="1">
						<option value="">#LB_Todos#</option>
						<cfloop query="rsCCTransacciones">
							<option value="#Trim(CCTcodigo)#" <cfif isdefined('form.CCTcodigo') and rsCCTransacciones.CCTcodigo EQ TRIM(form.CCTcodigo)>selected</cfif>>
								#CCTdescripcion#</option>
						</cfloop>
					</select>
				</cfoutput>
			</td>
		</tr>
		<tr>
		<cfoutput>        
			<td align="right">
					<input name="DocumentoSaldo" id="DocumentoSaldo" type="checkbox"<cfif isdefined('form.Documento')>checked="checked"</cfif>>
			</td>
<cfset LB_DoctosSaldo  = t.Translate('LB_DoctosSaldo','Documentos con Saldo')>
			<td><strong>#LB_DoctosSaldo#</strong></td>
		</cfoutput>            
		</tr>
		<tr>
			<td align="right"><strong><cfoutput>#LB_Timbre#: </cfoutput></strong></td>
			<td>
				<cfoutput>
					<select name="FTimbre"  tabindex="6">
						<option value="0" <cfif isdefined('form.FTimbre') and form.FTimbre EQ 0>selected</cfif>>#LB_TimbreA#</option>
						<option value="1" <cfif isdefined('form.FTimbre') and form.FTimbre EQ 1>selected</cfif>>#LB_TimbreS#</option>
						<option value="2" <cfif isdefined('form.FTimbre') and form.FTimbre EQ 2>selected</cfif>>#LB_TimbreC#</option>
					</select>
				</cfoutput>
			</td>
		</tr>
		<tr>
		<cfoutput>        
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>        
			<td align="right"><strong>#LB_Documento#:</strong></td>
			<td>
					<input name="Documento" id="Documento" type="text" size="40"
						value="<cfif isdefined('form.Documento')>#form.Documento#</cfif>"  tabindex="1">
			</td>
		</cfoutput>
		</tr>
        <tr>
<cfset LB_Centro_Funcional = t.Translate('LB_Centro_Funcional','Centro Funcional','/sif/generales.xml')>
<cfset LB_ListaCF = t.Translate('LB_ListaCF','Lista de Centros Funcionales')>
<cfset LB_DESCRIPCION = t.Translate('LB_DESCRIPCION','Descripcion','/sif/generales.xml')>
<cfset LB_Codigo = t.Translate('LB_Codigo','Codigo','/sif/generales.xml')>

			<td align="right"><strong><cfoutput>#LB_Centro_Funcional#:</cfoutput></strong></td>
			<td>
				<cf_conlis
                    Campos="CFid,CFcodigo,CFdescripcion"
                    Desplegables="N,S,S"
                    Modificables="N,S,N"
                    Size="0,10,40"
                    tabindex="5"
                    Title="#LB_ListaCF#"
                    Tabla="CFuncional cf 
                    inner join Oficinas o 
                    on o.Ecodigo=cf.Ecodigo 
                    and o.Ocodigo=cf.Ocodigo"
                    Columnas="distinct cf.CFid,cf.CFcodigo,cf.CFdescripcion"
                    Filtro=" cf.Ecodigo = #Session.Ecodigo# order by cf.CFcodigo"
                    Desplegar="CFcodigo,CFdescripcion"
                    Etiquetas="#LB_Codigo#,#LB_DESCRIPCION#"
                    filtrar_por="CFcodigo,CFdescripcion"
                    Formatos="S,S"
                    Align="left,left"
                    form="form1"
                    Asignar="CFid,CFcodigo,CFdescripcion"
                    Asignarformatos="S,S,S"											
                />
			</td>
		</tr>
        <tr>
			<td align="right"><strong><cfoutput>#LB_TipoItem#:</cfoutput></strong></td>
			<td>
				<cfoutput>
					<select name="TipoItem" tabindex="1">
						<option value="T">#LB_Todos#</option>
						<option value="A" <cfif isdefined('form.TipoItem') and form.TipoItem EQ 'A'>selected</cfif>>#LB_Articulo#</option>
						<option value="S" <cfif isdefined('form.TipoItem') and form.TipoItem EQ 'S'>selected</cfif>>#LB_Servicio#</option>
					</select>
				</cfoutput>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
<cfset BTN_Consultar = t.Translate('BTN_Consultar','Consultar','/sif/generales.xml')>
<cfset LB_btnLimpiar = t.Translate('LB_btnLimpiar','Limpiar','/sif/generales.xml')>
			<cfoutput>
			<td align="center" colspan="2">
				<!--- <input type="submit" name="btnConsultar"  id="btnConsultar" value="Consultar" onClick="javascript: valida()">
				<input type="reset" name="Limpiar" value="Limpiar" > --->
				<!---<cf_botones values="#BTN_Consultar#,#LB_btnLimpiar#" tabindex="1">--->
                <cf_botones values="Excel,Consultar,Limpiar" tabindex="1">
			</td>
			</cfoutput>
		</tr>
		
	</table>
</form>

<cfset MSG_FechaDoctDesde = t.Translate('MSG_FechaDoctDesde','La Fecha Documento Hasta debe ser mayor a la Fecha Documento Desde')>
<cfset MSG_FechaVencHasta = t.Translate('MSG_FechaVencHasta','La Fecha Vencimiento Hasta debe ser mayor a la Fecha Vencimiento Desde')>
<cfset MSG_FechaDesde = t.Translate('MSG_FechaDesde','Fecha Desde')>
<cfset MSG_FechaHasta = t.Translate('MSG_FechaHasta','Fecha Hasta')>

<cf_qforms>
<cfoutput>
<script language="javascript" type="text/javascript">
	objForm.fechaIni.required=true;
	objForm.fechaIni.description='#MSG_FechaDesde#';
	objForm.fechaFin.required=true;
	objForm.fechaFin.description='#MSG_FechaHasta#';

	function funcExcel(){
		document.form1.action            = "RFacturasCC2-Excel.cfm";
		document.form1.submit();

	}

	function funcConsultar(){ 
		document.form1.action            = "RFacturasCC2-reporte.cfm";
		var f = document.form1;
		if (datediff(f.fechaIni.value, f.fechaFin.value) < 0){	
			alert ('#MSG_FechaDoctDesde#');
			return false;
		}
		if (datediff(f.fechaVenIni.value, f.fechaVenFin.value) < 0){	
			alert ('#MSG_FechaVencHasta#');
			return false;
		} 
		document.form1.submit();
	}	

	function funcLimpiar(){
		var f = document.form1;
		f.SNnumero.value = '';
		f.SNnombre.value = '';
		f.fechaIni.value = '';
		f.fechaFin.value = '';
		f.fechaVenIni.value = '';
		f.fechaVenFin.value = '';
		f.CCTcodigo.value = '';
		f.Documento.value = '';
		f.CFid.value = '';
		f.CFcodigo.value = '';
		f.CFdescripcion.value = '';
		return false;
	}
</script>
</cfoutput>
