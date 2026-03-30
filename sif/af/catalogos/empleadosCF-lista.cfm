<!--- Definición de Parámetros --->
<cfset navegacion = "">
<cfif isDefined("url.CFidIni") and not isDefined("form.CFidIni")>
	<cfset form.CFidIni = url.CFidIni>
</cfif>
<cfif isDefined("url.CFidFin") and not isDefined("form.CFidFin")>
	<cfset form.CFidFin = url.CFidFin>
</cfif>

<cfif isDefined("form.CFidIni") and len(trim(form.CFidIni))>
	<cfset navegacion = navegacion & "&CFidIni=#form.CFidIni#">
</cfif>
<cfif isDefined("form.CFidFin") and len(trim(form.CFidFin))>
	<cfset navegacion = navegacion & "&CFidFin=#form.CFidFin#">
</cfif>

<cfquery name="rsEncarg" datasource="#session.DSN#">
	select '' as value, '-- Todos -- ' as description from dual
	union all
	select '0' as value, 'No encargado' as description from dual
	union all
	select '1' as value, 'Encargado' as description from dual
</cfquery>

<cfquery name="descripcion" datasource="#session.DSN#">
	select '' as value, '-- Todos -- ' as description from dual
	union all
	select '0' as value, 'Inactivo' as description from dual
	union all
	select '1' as value, 'Activo' as description from dual
</cfquery>


<!--- Lista de Empleados --->
<form name="form1" action="empleadosCF-form.cfm" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr class="tituloListas"><td colspan="4">&nbsp;</td></tr>

	<tr> 
		<td valign="top" colspan="3">
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaRH"
				returnvariable="pListaRet"
				tabla="DatosEmpleado b"
				columnas="
                	b.Ecodigo,
                    b.DEid,
                    b.DEidentificacion as identificacion,
                    b.DEnombre as nombre,
                    b.DEapellido1 as apellido1,
                    b.DEapellido2 as apellido2,
					 case when (
                            select count(1)
                            from EmpleadoCFuncional cf
                            where cf.DEid = b.DEid
                              and  #now()# between cf.ECFdesde and cf.ECFhasta) > 0 
                        then 'Activo' 
                        else 'Inactivo' 
                    end as descripcion,
                    case 
                        when ((
                            select count(1)
                            from EmpleadoCFuncional cf
                            where cf.DEid = b.DEid
                              and cf.ECFencargado = 1
                              and #now()# between cf.ECFdesde and cf.ECFhasta)) > 0 
                        then 
                        	'<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
                        else
                            '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'
                        end as encargadoIco,
                        '' as esp, 
                    
                    case 
                        when ((
                            select count(1)
                            from EmpleadoCFuncional cf
                            where cf.DEid = b.DEid
                              and cf.ECFencargado = 1
                              and #now()# between cf.ECFdesde and cf.ECFhasta)) > 0 
                        then 
                        	'1'
                        else
                            '0'
                        end as encargado"
				desplegar="identificacion,nombre,apellido1,apellido2,descripcion,encargadoIco,esp"
                etiquetas="Identificaci&oacute;n,Nombre,Primer Apellido,Segundo Apellido,Estado,Encargado, "
                formatos="S,S,S,S,S,S,US"
                filtro="Ecodigo = #session.Ecodigo# order by identificacion"
                align="left,left,left,left,left,center,left"
                ajustar="N"
                checkboxes="N"
                keys="DEid"
                MaxRows="20"
                MaxRowsQuery="500"
                filtrar_automatico="true"
                mostrar_filtro="true"
                filtrar_por="b.DEidentificacion,b.DEnombre,b.DEapellido1,b.DEapellido2,case when (
                            select count(1)
                            from EmpleadoCFuncional cf
                            where cf.DEid = b.DEid
                              and  #now()# between cf.ECFdesde and cf.ECFhasta) > 0 
                        then '1' 
                        else '0' 
                    end , 
			
                	case 
                        when ((
                            select count(1)
                            from EmpleadoCFuncional cf
                            where cf.DEid = b.DEid
                              and cf.ECFencargado = 1
                              and #now()# between cf.ECFdesde and cf.ECFhasta)) > 0 
                        then 
                        	1
                        else
                            0
                        end, "
                cortes=""
                navegacion="#navegacion#"
                irA="empleadosCF-form.cfm"
                botones="Nuevo"
                showEmptyListMsg="true"
                incluyeForm="false"
                formName="form1"
                rsencargadoIco="#rsEncarg#"
			       rsdescripcion="#descripcion#"/>

		</td>
	</tr>
</table>
</form>
<cfoutput>
</cfoutput>
