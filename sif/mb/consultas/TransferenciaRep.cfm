<!--- Metodo de Traduccion de Idioma --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" returnvariable="LB_Documento" xmlfile="TransferenciaRep.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripción" returnvariable="LB_Descripcion" xmlfile="TransferenciaRep.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" xmlfile="TransferenciaRep.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Periodo" default="Periodo" returnvariable="LB_Periodo" xmlfile="TransferenciaRep.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mes" default="Mes" returnvariable="LB_Mes" xmlfile="TransferenciaRep.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Todos" default="Todos" returnvariable="LB_Todos" xmlfile="TransferenciaRep.xml"/>

<cfquery datasource="#Session.DSN#" name="rsPeriodos">
	select distinct ETperiodo 
	from ETraspasos
	where Ecodigo = #session.Ecodigo#
	order by ETperiodo
</cfquery>	

<!-- 2. Combo Meses -->
<cfquery datasource="#Session.DSN#" name="rsMes">
	select distinct ETmes 
	from ETraspasos
	where Ecodigo = #session.Ecodigo#
	order by ETmes
</cfquery>

<cfset meses = ArrayNew(1)>
<cfset meses[1]  = "Enero">
<cfset meses[2]  = "Febrero">
<cfset meses[3]  = "Marzo">
<cfset meses[4]  = "Abril">
<cfset meses[5]  = "Mayo">
<cfset meses[6]  = "Junio">
<cfset meses[7]  = "Julio">
<cfset meses[8]  = "Agosto">
<cfset meses[9]  = "Septiembre">
<cfset meses[10] = "Octubre">
<cfset meses[11] = "Noviembre">
<cfset meses[12] = "Diciembre">

<cf_templateheader title="Consulta de Transferencias">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Transferencias Bancarias (sin aplicar)'>
		<form name="form1" method="post" action="TransferenciaRep_sql.cfm">
			<table border="0" cellpadding="0" cellspacing="2" width="100%">
				<tr>
					<td colspan="2">
						<cfinclude  template="../../portlets/pNavegacionMB.cfm">
					</td>
				</tr>	
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="right" width="50%"><strong><cfoutput>#LB_Documento#</cfoutput>:&nbsp;</strong></td>
					<td>
						<input type="text" name="Edocbase" value="<cfif isdefined ('form.Edocbase') and len(trim(form.Edocbase))><cfoutput>#form.Edocbase#</cfoutput></cfif>"/>
					</td>
				</tr>
				<tr>
					<td align="right" width="50%"><strong><cfoutput>#LB_Descripcion#</cfoutput>:&nbsp;</strong></td>
					<td>
						<input type="text" name="ETdescripcion" value="<cfif isdefined ('form.ETdescripcion') and len(trim(form.ETdescripcion))><cfoutput>#form.Edocbase#</cfoutput></cfif>"/>
					</td>
				</tr>
				<tr>
					<td align="right" width="50%"><strong><cfoutput>#LB_Fecha#</cfoutput>:&nbsp;</strong></td>
					<td>
						<cf_sifcalendario name="ETfecha">
					</td>
				</tr>
				<tr>
					<td align="right"><strong><cfoutput>#LB_Periodo#</cfoutput>:&nbsp;</strong></td>
					<td>
						<select name="ETperiodo" >
							<option value="all"><cfoutput>#LB_Todos#</cfoutput></option>
							<cfoutput query="rsPeriodos"> 
								<option value="#rsPeriodos.ETperiodo#" >#rsPeriodos.ETperiodo#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right"><strong><cfoutput>#LB_Mes#</cfoutput>:&nbsp;</strong></td>
					<td>
						<select name="ETmes" >
							<option value="all"><cfoutput>#LB_Todos#</cfoutput></option>
							<cfoutput query="rsMes"> 
								<option value="#rsMes.ETmes#" >#meses[rsMes.ETmes]#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td colspan="2" align="center">
						<input type="submit" name="btnConsultar" value="Consultar">
						<input type="button" name="btnLimpiar"   value="Limpiar" onClick="javascript:limpiar(this);">
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</form>            	
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript1.1" type="text/javascript">
	function limpiar(){
		document.form1.Edocbase.value='';
		document.form1.ETdescripcion.value='';
		document.form1.ETfecha.value='';
	}
</script>