<cfif isdefined("url.formulario") and len(trim(url.formulario))>
	<cfset form.formulario = url.formulario>
</cfif>
<cfif isdefined("url.Ddocumento") and not isdefined("form.Ddocumento")>
	<cfset form.Ddocumento= url.Ddocumento >
</cfif>
<cfif isdefined("url.CPcodigo") and not isdefined("form.CPcodigo")>
	<cfset form.CPcodigo= url.CPcodigo >
</cfif>
<cfif isdefined("url.EDIfecha") and not isdefined("form.EDIfecha")>
	<cfset form.EDIfecha= url.EDIfecha >
</cfif>
<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo= url.SNcodigo >
</cfif>
<cfif isdefined("url.EPDid") and not isdefined("form.EPDid")>
	<cfset form.EPDid= url.EPDid >
</cfif>
<cfif isdefined("url.SNcodigoDcto") and not isdefined("form.SNcodigoDcto")>
	<cfset form.SNcodigoDcto= url.SNcodigoDcto >
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.formulario") and Len(Trim(Form.formulario)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "formulario=" & Form.formulario>
</cfif>
<cfif isdefined("Form.Ddocumento") and Len(Trim(Form.Ddocumento)) NEQ 0>
	<cfset filtro = filtro & " and upper(edi.Ddocumento) like '%" & #UCase(Form.Ddocumento)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Ddocumento=" & Form.Ddocumento>
</cfif>
<cfif isdefined("Form.CPcodigo") and Len(Trim(Form.CPcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(edi.CPcodigo) like '%" & #UCase(Form.CPcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPcodigo=" & Form.CPcodigo>
</cfif>
<cfif isdefined("Form.EDIfecha") and Len(Trim(Form.EDIfecha)) NEQ 0>
	<cfset filtro = filtro & " and edi.EDIfecha = "  & Form.EDIfecha>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EDIfecha=" & Form.EDIfecha>
</cfif>
<cfif isdefined("Form.SNcodigo") and Len(Trim(Form.SNcodigo)) NEQ 0>
	<cfset filtro = filtro & " and edi.SNcodigo = " & Form.SNcodigo>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNcodigo=" & Form.SNcodigo>
</cfif>
<cfif isdefined("Form.EPDid") and Len(Trim(Form.EPDid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EPDid=" & Form.EPDid>
</cfif>
<cfif isdefined("Form.SNcodigoDcto") and Len(Trim(Form.SNcodigoDcto)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNcodigoDcto=" & Form.SNcodigoDcto>
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar(ediid,ddocumento) {
	if (window.opener != null) {
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.EDIidref.value = ediid;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.DdocumentoRef.value = ddocumento;		
		window.close();
	}
}
</script>

<cfinclude template="../../Utiles/sifConcat.cfm">
<!-----Query de la lista------>
<cfquery name="rsdatos" datasource="#session.dsn#">
	select distinct edi.EDIid, edi.Ddocumento, moneda.Mnombre, edi.EDIfecha, socio.SNnumero #_Cat# ' ' #_Cat# socio.SNnombre as SocioDesc
	from EDocumentosI edi
		inner join Monedas moneda 
			on moneda.Mcodigo = edi.Mcodigo
		inner join SNegocios socio
			on socio.Ecodigo = edi.Ecodigo
			and socio.SNcodigo = edi.SNcodigo
		inner join DDocumentosI ddi
			on ddi.EDIid = edi.EDIid
	where edi.EDIestado = 10
		and edi.EDItipo = 'F'
		#preservesinglequotes(filtro)#	
		and edi.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("form.EPDid") and len(trim(form.EPDid))>
			and edi.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
		</cfif>
		<cfif isdefined("form.SNcodigoDcto") and len(trim(form.SNcodigoDcto))>
			and edi.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigoDcto#">
		</cfif>
        <cfif not isdefined("form.EPDid")><!----Si no viene la póliza, filtra por las que no estén asociadas a una póliza------>
            and (
                select count(1)
                from DPolizaDesalmacenaje y
                    inner join EPolizaDesalmacenaje x
                       on x.EPDid   = y.EPDid
                      and x.Ecodigo = y.Ecodigo
                where y.DDlinea = ddi.DDlinea
                 and x.EPDestado = 0
                and x.Ecodigo = edi.Ecodigo
            ) = 0 
        </cfif>
</cfquery>

<!---Combo de tipos de transaccion---->
<cfquery name="rsTiposTransaccion" datasource="#session.DSN#">
	select CPcodigo, CPdescripcion
	from TTransaccionI
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
</cfquery>

<html>
<head>
<title>Lista de Facturas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>

<form style="margin:0;" name="conlisFacturas" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td width="1%" align="right"><strong>Documento</strong></td>
		<td> 
			<input name="Ddocumento" type="text" id="name" size="30" maxlength="30" value="<cfif isdefined("Form.Ddocumento") and len(trim(Form.Ddocumento))>#Form.Ddocumento#</cfif>" onFocus="javascript:this.select();" >
		</td>
		<td width="1%" align="right"><strong>Tipo</strong></td>
		<td>
			<select name="CPcodigo">
				<option value="">--Todos--</option>
				<cfloop query="rsTiposTransaccion">
					<option value="#rsTiposTransaccion.CPcodigo#" <cfif isdefined("Form.CPcodigo") and len(trim(Form.CPcodigo))>selected</cfif>>#rsTiposTransaccion.CPdescripcion#</option>
				</cfloop>
			</select>			
		</td>
		<td width="1%" align="right"><strong>Fecha</strong></td>
		<td>			
			<cfif isdefined("form.EDIfecha") and len(trim(Form.EDIfecha))>
				<cfset vdFecha = LSDateFormat(form.EDIfecha,'dd/mm/yyyy') >
			<cfelse>
				<cfset vdFecha = "">
			</cfif>
			<cf_sifcalendario value="#vdFecha#" tabindex="6" name="EDIfecha" form="conlisFacturas">					
		</td>	
<!---	</tr>			
	<tr>*----->
		<td width="1%" align="right" nowrap><strong>Socio Negocio</strong></td>
		<td>
			<cfif isdefined("form.SNcodigo") and len(trim(Form.SNcodigo))>
				<cfset vnSocio = form.SNcodigo>
			<cfelse>
				<cfset vnSocio = "">
			</cfif>
			<cf_sifsociosnegocios2 tabindex="8" SNtiposocio="P" size="30" idquery="#vnSocio#" form="conlisFacturas">
		</td>
		
		<td align="center" colspan="4">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>	
</table>
</form>
</cfoutput>

<cfinvoke component="sif.Componentes.pListas"	method="pListaQuery" returnvariable="pListaRet">
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="query" value="#rsdatos#"/>
	<cfinvokeargument name="desplegar" value="Ddocumento, Mnombre, EDIfecha, SocioDesc"/>
	<cfinvokeargument name="etiquetas" value="Documento, Moneda, Fecha, Socio"/>
	<cfinvokeargument name="formatos" value="V,V,D,V"/>
	<cfinvokeargument name="align" value="left, left, left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisFacturas.cfm"/>
	<cfinvokeargument name="formName" value="listaFacturas"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="EDIid,Ddocumento"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>
</body>
</html>
