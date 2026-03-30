<cfparam name="modo" default="ALTA">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<!---<cfdump var="#form#">--->
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
<cf_web_portlet_start border="true" titulo="Aprobación de Movimientos" skin="#Session.Preferences.Skin#">
<cf_dbfunction name="OP_CONCAT"returnvariable="_Cat">
<cfquery name="rsDepositos" datasource="#session.dsn#">
	select pdtd.PDTDid, pdtd.BTid, p.Pcodigo, pt.PTcodigo, pet.PETfecha, m.Mnombre , pdtd.PDTDmonto,pdtd.PDTDdocumento,
		b.Bdescripcion #_Cat# ' - ' #_Cat# cb.CBcodigo as banco
	from PDTDeposito pdtd
		inner join CuentasBancos cb
			inner join Bancos b
				on cb.Bid = b.Bid and cb.Ecodigo = b.Ecodigo
			inner join Monedas m 
				on m.Mcodigo = cb.Mcodigo
			on cb.CBid = pdtd.CBid
		inner join PETransacciones pet
			inner join Peaje p
				on p.Pid = pet.Pid 
			inner join PTurnos pt
				on pt.PTid = pet.PTid
		on pdtd.PETid = pet.PETid
	where pdtd.PDTDestado = 2
    and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	and pet.Ecodigo=#session.Ecodigo#
	<cfif isdefined('form.filtro_Pcodigo') and len(trim(form.filtro_Pcodigo))>
		and lower(p.Pcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_Pcodigo)#%">
	</cfif>
	<cfif isdefined('form.filtro_PTcodigo') and len(trim(form.filtro_PTcodigo))>
		and lower(pt.PTcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_PTcodigo)#%">
	</cfif>
	<cfif isdefined('form.filtro_banco') and len(trim(form.filtro_banco))>
		and (lower(b.Bdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_banco)#%">
			or lower(cb.CBcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_banco)#%">)
	</cfif>
	<cfif isdefined('form.filtro_PDTDdocumento') and len(trim(form.filtro_PDTDdocumento))>
		and lower(pdtd.PDTDdocumento) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_PDTDdocumento)#%">
	</cfif>
	<cfif isdefined('form.filtros_PDTDmonto') and len(trim(form.filtros_PDTDmonto))>
		and pdtd.PDTDmonto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.filtros_PDTDmonto,',','','ALL')#">
	</cfif>
	<cfif isdefined('form.filtro_Mnombre') and len(trim(form.filtro_Mnombre)) and form.filtro_Mnombre neq -1>
		and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.filtro_Mnombre#">
	</cfif>
	<cfif isdefined('form.filtro_PETfecha') and len(trim(form.filtro_PETfecha))>
			<cfif isdefined('form.filtro_FECHASMAYORES')>
				and pet.PETfecha > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.filtro_PETfecha)#">
			<cfelse> 
				and pet.PETfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.filtro_PETfecha)#">
			</cfif>
		</cfif>
	order by pet.PETfecha DESC, p.Pcodigo DESC, pt.PTcodigo DESC
</cfquery>
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select -1 as value, '-- todos --' as description, 0 as ord from dual
	union
	select Mcodigo as value, Mnombre as description, 1 as ord
	from Monedas
	where Ecodigo = #Session.Ecodigo#
	order by ord,description
</cfquery>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">		        
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsDepositos#" 
				conexion="#session.dsn#"
				desplegar="Pcodigo, PTcodigo, banco, PDTDdocumento,PDTDmonto, Mnombre, PETfecha"
				etiquetas="Cód. Peaje , Cód. Turno, Banco - Cuenta, N° documento, Monto, Moneda, Fecha Reg. Mov"
				formatos="S,S,S,S,M,S,D"
				mostrar_filtro="true"
				align="left,left,left,left,left,left,left"
				ira="aprobacionDepositos.cfm"
				checkboxes="N"
				rsMnombre="#rsMonedas#"
				keys="PDTDid">
			</cfinvoke>
		</td> 
	</tr>
</table>
<cf_web_portlet_end>
<cf_templatefooter>