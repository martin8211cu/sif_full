<cfparam name="modo" default="ALTA">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
<cf_web_portlet_start border="true" titulo="Ajustes de Movimientos" skin="#Session.Preferences.Skin#">
<cfquery name="rsAjustes" datasource="#session.dsn#">
	select pa.PAid, p.Pcodigo, b.Bdescripcion, bt.BTdescripcion, pa.PAdocumento, pa.PAdescripcion, pa.PAmonto, m.Mnombre
	from PAjustes pa
		inner join CuentasBancos cb
			inner join Bancos b
				on cb.Bid = b.Bid and cb.Ecodigo = b.Ecodigo
			inner join Monedas m 
				on m.Mcodigo = cb.Mcodigo
			on cb.CBid = pa.CBid
		inner join Peaje p
			on p.Pid = pa.Pid
		inner join BTransacciones bt
			on bt.BTid = pa.BTid
	where pa.PAestado = 1
    	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		and p.Ecodigo = #session.Ecodigo#
		<cfif isdefined('form.filtro_Pcodigo') and len(trim(form.filtro_Pcodigo))>
		and lower(p.Pcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_Pcodigo)#%">
		</cfif>
		<cfif isdefined('form.filtro_Bdescripcion') and len(trim(form.filtro_Bdescripcion))>
		and lower(b.Bdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_Bdescripcion)#%">
		</cfif>
		<cfif isdefined('form.filtro_BTdescripcion') and len(trim(form.filtro_BTdescripcion)) and form.filtro_BTdescripcion neq -1>
		and bt.BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.filtro_BTdescripcion#">
		</cfif>
		<cfif isdefined('form.filtro_PAdocumento') and len(trim(form.filtro_PAdocumento))>
		and lower(pa.PAdocumento) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_PAdocumento)#%">
		</cfif>
		<cfif isdefined('form.filtro_PAdescripcion') and len(trim(form.filtro_PAdescripcion))>
		and lower(pa.PAdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_PAdescripcion)#%">
		</cfif>
		<cfif isdefined('form.filtro_Mnombre') and len(trim(form.filtro_Mnombre)) and form.filtro_Mnombre neq -1>
		and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.filtro_Mnombre#">
		</cfif>
	order by p.Pcodigo DESC
</cfquery>
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select -1 as value, '-- todos --' as description, 0 as ord from dual
	union
	select Mcodigo as value, Mnombre as description, 1 as ord
	from Monedas
	where Ecodigo = #Session.Ecodigo#
	order by ord,description
</cfquery>
<cfquery name="BTransacciones" datasource="#Session.DSN#">
	select -1 as value, '-- todos --' as description from dual
	union
	select BTid as value, BTdescripcion as description
	from BTransacciones
	where Ecodigo = #Session.Ecodigo#
	order by description
</cfquery>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">		        
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsAjustes#" 
				conexion="#session.dsn#"
				desplegar="Pcodigo, Bdescripcion, BTdescripcion, PAdocumento, PAdescripcion, PAmonto, Mnombre"
				etiquetas="Cód. Peaje , Banco, Tipo Transacción, Documento, Descripción, Monto, Moneda"
				formatos="S,S,S,S,S,M,S"
				mostrar_filtro="true"
				align="left,left,left,left,left,right,left"
				ira="ajustes.cfm"
				checkboxes="S"
				botones="Eliminar,Nuevo"
				rsMnombre="#rsMonedas#"
				rsBTdescripcion="#BTransacciones#"
				keys="PAid">
			</cfinvoke>
		</td> 
	</tr>
</table>
<cfoutput>
<script language="javascript1.2" type="text/javascript">
	
	function algunoMarcado(){
		f = document.lista;
		if (f.chk != null) {
			if (f.chk.value) {
				if (f.chk.checked) {
					return true;
				}
			} else {
				for (var i=0; i<f.chk.length; i++) {
					if (f.chk[i].checked) {
						return true;
					}
				}
			}
		} 
		alert("Debe marcar al menos un elemento de la lista para realizar esta accion!");
		return false;
	}

	function funcEliminar(){
		if (algunoMarcado()){
			if(confirm("Desea eliminar los datos marcados?"))
				return true;
			else
				return false;
		}
		else
			return false; 
		return false;
	}
</script>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>