<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 10-3-2006.
		Motivo: Se corrige la navegaciÃ³n del form por tabs para que tenga un orden lÃ³gico.
 --->
<cfquery name="rsTiposRep" datasource="#Session.DSN#">
	select CGARepid, CGARepDes
	from CGAreasTipoRep
	where CGARepid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fCGARepid#">
</cfquery>

<cfset filtro = "">

<cfif isdefined("Form.fCGARepid") and Len(Trim(Form.fCGARepid))>
	<cfset filtro = filtro & " and a.CGARepid = " & Form.fCGARepid>
</cfif>

<cfoutput>
<cfset campos = "">
<form name="filtro2" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
	<input type="hidden" name="fCGARepid" value="<cfif isdefined ("form.fCGARepid") and len(trim(form.fCGARepid))><cfoutput>#form.fCGARepid#</cfoutput></cfif>">
	<input name="tab" type="hidden" value="2">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="tituloAlterno" align="center" style="text-transform: uppercase; ">
			<strong>Lista de Cuentas a Eliminar por Tipo de Reporte</strong>
		</td>
      </tr>
	  <tr>
		<td valign="top">
			
			<cfif len(campos) gt 0>
				<cfif mid(trim(campos),len(trim(campos)),1) eq "," >
					<cfset campos = "," & mid(trim(campos),1,(len(trim(campos))-1)) & " ">
				<cfelse>
					<cfset campos = "," & campos & " ">
				</cfif>
			</cfif>
			<cfset params = '?tab=2'>
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pLista"
				returnvariable="pListaRet"
				columnas="a.CGARepid, e.Edescripcion, o.Odescripcion, c.Cdescripcion, a.Ccuenta, a.Ocodigo"
				tabla="CGAreasTipoRepCtasEliminar a
						inner join Empresas e
							on e.Ecodigo = a.Ecodigo
						inner join Oficinas o
							on o.Ecodigo = a.Ecodigo
							and o.Ocodigo = a.Ocodigo
						inner join CContables c
							on c.Ccuenta = a.Ccuenta"
				filtro="1=1 #PreserveSingleQuotes(filtro)# order by Odescripcion"
				desplegar="Edescripcion, Odescripcion, Cdescripcion"
				etiquetas="Empresa, Oficina, Cuenta"
				formatos="S,S,U"
				align="left, left, left"
				checkboxes="N"
				ira="CuentasTipoRep_Option.cfm#params#"
				nuevo="CuentasTipoRep_Option.cfm#params#"
				showLink="true"
				showemptylistmsg="true"
				incluyeform="false"
				formname="filtro2"
				keys="Ccuenta,Ocodigo,CGARepid"
				mostrar_filtro="true"
				filtrar_automatico="true"
				filtrar_por="Edescripcion, Odescripcion, ' '"
				maxrows="15"
				navegacion="#navegacion#&tab=2"
				/>
			</form>
		</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
      </tr>
	</table>
</cfoutput>

