
<cfset modo = 'Alta'>
<cfif isdefined("form.QPUOid") and len(trim(form.QPUOid)) and not isdefined("form.Nuevo")>
	<cfset modo = 'Cambio'>
</cfif>

<cfif modo neq 'Alta'>
    <cfquery name="rsQPassUsuarioOficina" datasource="#session.DSN#">
        select
            QPUOid, 
            Ecodigo,
            Ocodigo,
            Usucodigo
        from QPassUsuarioOficina
        where QPUOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPUOid#">
    </cfquery>
</cfif>

<cfoutput>
    <form name="form1" action="QPassUsuxOfi_SQL.cfm" method="post">
    	<input name="QPUOid" type="hidden" value="<cfif modo neq 'Alta'>#form.QPUOid#</cfif>" tabindex="1"/>
        <table cellpadding="2" cellspacing="0" border="0">
	        <tr>
                <td align="right">
                    <strong>Usuario:</strong>&nbsp;
                </td>
                <td align="left">
	                <cfset valuesArray = ArrayNew(1)>
					<cfif isdefined("rsQPassUsuarioOficina") and LEN(rsQPassUsuarioOficina.Usucodigo) GT 0>
						<cfquery name="rsQPTOConlisUsu" datasource="#session.DSN#">
							select u.Usucodigo, u.Usulogin, p.Pid, p.Pnombre, p.Papellido1, p.Papellido2
							from Usuario u 
                        	   inner join DatosPersonales p 
                               		on p.datos_personales = u.datos_personales 
                               inner join QPassUsuarioOficina o
									on o.Usucodigo = u.Usucodigo
							where u.Usucodigo = #rsQPassUsuarioOficina.Usucodigo#
                            and u.CEcodigo = #session.CEcodigo# 
                            and u.Uestado = 1 
						</cfquery>
						<cfset ArrayAppend(valuesArray, rsQPTOConlisUsu.Usucodigo)>
                        <cfset ArrayAppend(valuesArray, rsQPTOConlisUsu.Usulogin)>
                        <cfset ArrayAppend(valuesArray, rsQPTOConlisUsu.Pid)>
                        <cfset ArrayAppend(valuesArray, rsQPTOConlisUsu.Pnombre)>
                        <cfset ArrayAppend(valuesArray, rsQPTOConlisUsu.Papellido1)>
                        <cfset ArrayAppend(valuesArray, rsQPTOConlisUsu.Papellido2)>
					</cfif>
                	<cf_dbfunction name="to_number" args="b.llave" returnvariable= 'llaveB'>
                    <cf_conlis
                        Campos="Usucodigo, Usulogin, Pid, Pnombre, Papellido1, Papellido2"
                        Desplegables="N,S,S,S,S,S"
                        Modificables="N,S,N,N,N,N"
                        Size="0,10,7,7,7,7"
                        tabindex="1"
                        valuesarray="#valuesArray#" 
                        Title="Lista de Usuarios Activos"
                        Tabla="Usuario u 
                        	   inner join DatosPersonales p 
                               		on p.datos_personales = u.datos_personales "
                        Columnas="u.Usucodigo, u.Usulogin, p.Pid, p.Pnombre, p.Papellido1, p.Papellido2" 
                        Filtro=" u.CEcodigo = #session.CEcodigo#
                        	and u.Uestado = 1 
                            group by 
                                u.Usucodigo, 
                                u.Usulogin, 
                                p.Pid, 
                                p.Pnombre, 
                                p.Papellido1, 
                                p.Papellido2"
                        Desplegar="Usulogin, Pid, Pnombre, Papellido1, Papellido2"
                        Etiquetas="Login, Identificacion, Nombre, Apellido1, Apellido2"
                        filtrar_por="Usulogin, Pid, Pnombre, Papellido1, Papellido2"
                        Formatos="S,S,S,S,S"
                        Align="left,left,left,left"
                        form="form1"
                        Asignar="Usucodigo, Usulogin, Pid, Pnombre, Papellido1, Papellido2"
                        Asignarformatos="S,S,S,S,S,S"
                        width="800"
                    />
                </td>
            </tr>
            <tr>
                <td align="right">
                    <strong>Sucursal:</strong>&nbsp;
                </td>
                <td align="left">
                	<cfset valuesArray = ArrayNew(1)>
					<cfif isdefined("rsQPassUsuarioOficina") and LEN(rsQPassUsuarioOficina.Ocodigo) GT 0>
						<cfquery name="rsQPTOConlisOfi" datasource="#session.DSN#">
							select Ocodigo, Oficodigo, Odescripcion
							from Oficinas a
							where Ecodigo = #session.Ecodigo#
                            and Ocodigo   = #rsQPassUsuarioOficina.Ocodigo#
						</cfquery>
						<cfset ArrayAppend(valuesArray, rsQPTOConlisOfi.Ocodigo)>
                        <cfset ArrayAppend(valuesArray, rsQPTOConlisOfi.Oficodigo)>
                        <cfset ArrayAppend(valuesArray, rsQPTOConlisOfi.Odescripcion)>
					</cfif>
                    <cf_conlis
                        Campos="Ocodigo, Oficodigo, Odescripcion"
                        Desplegables="N,S,S"
                        Modificables="N,S,N"
                        Size="0,10,15"
                        tabindex="1"
                        valuesarray="#valuesArray#" 
                        Title="Lista de Sucursales"
                        Tabla="Oficinas a"
                        Columnas="Ocodigo, Oficodigo, Odescripcion" 
                        Filtro=" Ecodigo = #session.Ecodigo#"
                        Desplegar="Oficodigo, Odescripcion"
                        Etiquetas="Código, Descripción"
                        filtrar_por="Oficodigo, Odescripcion"
                        Formatos="S,S"
                        Align="left,left,"
                        form="form1"
                        Asignar="Ocodigo, Oficodigo, Odescripcion"
                        Asignarformatos="S,S,S"
                        width="800"
                    />
                </td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="2">
                    <cf_botones modo="#modo#" tabindex="1" include="Importar">
                </td>
            </tr>
        </table>
    </form>
</cfoutput>
<cf_qforms form="form1">
    <cf_qformsrequiredfield args="Usucodigo,Usuario">
    <cf_qformsrequiredfield args="Ocodigo,Oficina">
</cf_qforms>
<script language="javascript" type="text/javascript">
	function funcNuevo(){
		document.form1.action='QPassUsuxOfi.cfm';
		document.form1.submit;
	}
	function funcImportar(){
		deshabilitarValidacion();
		document.form1.action='/cfmx/sif/QPass/importar/ImportarUsuariosXSucursal_form.cfm';
		document.form1.submit;
		}
</script>