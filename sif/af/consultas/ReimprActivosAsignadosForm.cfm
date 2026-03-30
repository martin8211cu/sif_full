<!---
	Creado por: Maria de los Angeles Blanco López
		Fecha: 29 Agosto 2011
 --->

<cf_templateheader title="Reimpresipon de Resguardos">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reimpresión de Resguardos'>

<cf_dbfunction name="now" returnvariable="hoy">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfquery datasource="#session.dsn#" name="rsTipoDoc">
	select CRTDcodigo, CRTDdescripcion
	from CRTipoDocumento
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfoutput>
<form name="form1" method="post">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td valign="top">
				<table  width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td> <strong>Tipo Documento</strong><br/><br/>
						<select name="fltTipoDoc">
		            		<option value="-1" selected="selected">--Todos--</option>
    		        		<cfloop query="rsTipoDoc">
        		        		<option value="#rsTipoDoc.CRTDcodigo#" <cfif isdefined("form.fltTipoDoc") and trim(form.fltTipoDoc) EQ trim(rsTipoDoc.CRTDcodigo)>selected="selected"</cfif>>#rsTipoDoc.CRTDcodigo# - #rsTipoDoc.CRTDdescripcion#</option>
            				</cfloop>
            			</select>
						</td>
						
						<td> <strong>Empleado</strong><br /><br/>
						<cf_conlis title="LISTA DE EMPLEADOS"
							campos = "DEid, DEidentificacion, DEnombreTodo"
							desplegables = "N,S,S"
							modificables = "N,S,N"
							size = "0,8,25"
							asignar="DEid, DEidentificacion, DEnombreTodo"
							asignarformatos="S,S,S"
							tabla="DatosEmpleado"
							columnas="DEid, DEidentificacion, DEnombre +' '+ DEapellido1 +' '+ DEapellido2 as DEnombreTodo,DEnombre,DEapellido1,DEapellido2"
							filtro="Ecodigo = #Session.Ecodigo#"
							desplegar="DEidentificacion, DEnombre,DEapellido1,DEapellido2"
							etiquetas="Identificacin,Nombre,DEapellido1,DEapellido2"
							formatos="S,S,S,S"
							align="left,left,left,left"
							showEmptyListMsg="true"
							EmptyListMsg=""
							form="form1"
							width="800"
							height="500"
							left="70"
							top="20"
							filtrar_por="DEidentificacion,DEnombre,DEapellido1,DEapellido2"
							index="1"
							fparams="DEid"/>
						</td>
						<td> <strong>Centro Funcional</strong><br /><br/>
						<cf_conlis
							Campos="CFid, CFcodigo, CFdescripcion"
							Desplegables="N,S,S"
							Modificables="N,S,N"
							Size="0,8,25"
							tabindex="2"
							Title="Lista de Centros Funcionales"
						    Tabla= "CFuncional"
							Columnas="CFid, CFcodigo, CFdescripcion"
							Filtro="Ecodigo = #Session.Ecodigo#"
							Desplegar="CFcodigo, CFdescripcion"
						    Etiquetas="Codigo, Descripción"
							filtrar_por="CFcodigo, CFdescripcion"
							Formatos="S,S"
							Align="left,left"
							form="form1"
							Asignar="CFid,CFcodigo, CFdescripcion"
							Asignarformatos="S,S,S"
							showEmptyListMsg="true"
							EmptyListMsg="-- No se encontrarón Centros Funcionales --">
						</td>
						<td  align="center"><cf_botones values="Filtrar" names="Filtrar" tabindex="2"></td>
						<tr>
					</tr>
			</table>

			<table width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr>

    		<cfquery name="rsLista" datasource="#session.dsn#">
				select g.DEid, g.DEidentificacion  as Cedula,
				g.DEnombre + ' ' + g.DEapellido1 + ' ' + g.DEapellido2 as Nombre,
				CFuncional = CFACT.CFcodigo +' '+CFACT.CFdescripcion
				from AFResponsables a
			    inner join CRCentroCustodia b on b.Ecodigo = a.Ecodigo and b.CRCCid = a.CRCCid
				inner join Activos c on c.Aid = a.Aid and c.Ecodigo = a.Ecodigo
			    left outer join CRTipoDocumento d on d.Ecodigo = a.Ecodigo and d.CRTDid =a.CRTDid
			    left outer join ACategoria e on e.Ecodigo = c.Ecodigo and e.ACcodigo =c.ACcodigo
			    left outer join AClasificacion f  on f.Ecodigo = e.Ecodigo and f.ACcodigo =e.ACcodigo and f.ACid =c.ACid
			    left outer join DatosEmpleado  g on a.DEid 	= g.DEid
				left outer join EmpleadoCFuncional ef on ef.DEid = g.DEid 
								and GETDATE() between convert(datetime,ECFdesde) and convert(datetime,ECFhasta)
				left outer join CFuncional CFACT on CFACT.CFid = ef.CFid
			    left outer join Usuario h on a.Usucodigo = h.Usucodigo
				where a.Ecodigo =  #Session.Ecodigo#
				<cfif isdefined("DEid") and len(DEid) gt 0>
			    	and a.DEid = #DEid#
			    </cfif>
				<cfif isdefined("form1.TipoVale") and form1.TipoVale neq -1>
					and a.CRTDid = #form1.TipoVale#
				</cfif>
				<cfif isdefined("CFid") and len(CFid) gt 0 and isdefined("CFcodigo") and len(CFcodigo) gt 0>
			    	and a.CFid = #CFid#
			    </cfif>
				group by g.DEid, g.DEidentificacion, g.DEnombre , g.DEapellido1 , g.DEapellido2, CFACT.CFcodigo, 	                CFACT.CFdescripcion
		        order by g.DEidentificacion
		</cfquery>
			</td>
    		</tr>
			</table>
		</td>
		</tr>
	</table>
	</form>

	 <cfinvoke
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="cortes" value=""/>
			<cfinvokeargument name="desplegar" value="Cedula, Nombre, CFuncional"/>
			<cfinvokeargument name="etiquetas" value="Identificación, Nombre Empleado, Centro Funcional"/>
			<cfinvokeargument name="formatos" value="S,S,S"/>
			<cfinvokeargument name="ajustar" value="N,N,N"/>
			<cfinvokeargument name="align" value="center,left, left"/>
			<cfinvokeargument name="checkboxes" value=""/>
			<cfinvokeargument name="irA" value="ImprActivosAsignados.cfm"/>
            <cfinvokeargument name="MaxRows" value="20"/>
			<cfinvokeargument name="showLink" value="true"/>
			<cfinvokeargument name="keys" value="DEid"/>
			<cfinvokeargument name="botones" value=""/>
            <cfinvokeargument name="navegacion" value=""/>
	</cfinvoke>


</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>
<cfset session.ListaReg = "">
