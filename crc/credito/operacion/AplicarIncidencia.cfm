<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Aplicar Incidencia" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="T&iacute;tulo" returnvariable="LB_Titulo"/>

<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		
		<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
		<cfset val = objParams.getParametroInfo('30200711')>
		<cfif val.codigo eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no existe"></cfif>
		<cfif val.valor eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no esta definido"></cfif>
		
		<cfquery name="checkRol" datasource="#session.dsn#">
			select * from UsuarioRol where 
						Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.usucodigo#">  
					and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#val.valor#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#"> 
		</cfquery>

		<cfif checkRol.recordCount neq 0>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2">
						<cfinclude template="/home/menu/pNavegacion.cfm">
					</td>
				</tr>
				<tr>
					<td width="50%" valign="top">
						<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
							tabla="CRCIncidenciasCuenta i
									inner join CRCCuentas c
										on c.id = i.CRCCuentasid
									inner join SNegocios sn
										on sn.SNid = c.SNegociosSNid
									left join DatosEmpleado de
										on de.DEid = i.DatosEmpleadoDEid"
							columnas="
									sn.SNid
									, c.id as ID_cta
									, i.id as ID_inci
									, sn.SNidentificacion
									, sn.SNnombre
									, c.Numero
									, c.Tipo
									, i.Observaciones
									, case i.TipoEmpleado
											when 'GE' then 'Gestor'
											when 'AB' then 'Abogado'
											else 'N/D'
										end as TipoEmpleadoInci
									, i.Monto
									, i.TransaccionPendiente
									, i.DatosEmpleadoDEid
									, CONCAT(de.DEnombre,' ',de.DEapellido1,' ',de.DEapellido2) as DENombre"
							desplegar="SNidentificacion,SNnombre,Numero,Tipo,Observaciones,Monto,DENombre,TipoEmpleadoInci"
							etiquetas="Identificacion,Nombre,Numero Cuenta,Tipo Cuenta,Observaciones,Monto,Reportada Por,Tipo de Empleado"
							formatos="S,S,S,S,S,M,S,S"
							filtro="i.Ecodigo=#session.Ecodigo# AND i.TransaccionPendiente = 0"
							align="left,left,left,left,left,left,left,left"
							checkboxes="S"
							mostrar_filtro="true"
							filtrar_por="SNidentificacion,SNnombre,Numero,Tipo,Observaciones,Monto,DENombre,TipoEmpleadoInci"
							filtrar_automatico="true"
							showLink ="false"
							checkall="S"
							checkbox_function ="funcChk(this)"
							botones="Aplicar,Eliminar"
							formName="form1"
							ira="AplicarIncidencia_sql.cfm"
							keys="ID_inci">
						</cfinvoke>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
			</table>
			<cfoutput>
				<cfif isdefined("form.resultT") and #form.resultT# neq ""> 
					<script type="text/javascript">
						alert("#form.resultT#");
					</script> 
				</cfif>	
			</cfoutput>
		<cfelse>
			<cfthrow message="No cuentas con los permisos para realizar esta operacion">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>

<script>
    document.form1.btnEliminar .value='Rechazar'
    function funcChk(e){
        if(document.getElementsByName('chkAllItems')[0].checked && !e.checked){
            document.getElementsByName('chkAllItems')[0].checked = false;
        }
    }

	function ValidarSeleccion(){
        var checked = false;
        var chks = document.getElementsByName('chk');
        for(var i in chks){ if(chks[i].checked){checked = true;} }
        if(!checked){
            alert("No ha seleccionado al menos 1 incidencia");
            return false;
        }
        return true;
	}

	function funcAplicar(){
		if(ValidarSeleccion()){
			return confirm("Esta seguro que quiere APLICAR estas incidencias?");
		}
		return false;
	}

	function funcEliminar(){
		if(ValidarSeleccion()){
			return confirm("Esta seguro que quiere RECHAZAR estas incidencias?");
		}
		return false;
	}

</script>