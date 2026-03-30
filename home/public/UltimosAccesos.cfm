<cf_templateheader title="Detalle del &Uacute;ltimo Ingreso por Funcionario"><cf_web_portlet_start titulo="Detalle del &Uacute;ltimo Ingreso por Funcionario">
<cfinclude template="/home/menu/pNavegacion.cfm">

<cfquery datasource="minisif" name="accesos">
	select g.Edescripcion,e.DEidentificacion,e.DEnombre,e.DEapellido1,e.DEapellido2,
    a.Usucodigo,a.ip,a.login, (select max(x.acceso) from aspmonitor..MonProcesos x where x.Usucodigo=a.Usucodigo) as acceso 
, (select count(x.acceso) from aspmonitor..MonProcesos x where x.Usucodigo=a.Usucodigo) as cantidad     
        from aspmonitor..MonProcesos a
        inner join Usuario b
        on b.Usucodigo = a.Usucodigo
        inner join DatosPersonales c
        on c.datos_personales = b.datos_personales
        inner join UsuarioReferencia d
        on d.Usucodigo = a.Usucodigo
        and STabla='DatosEmpleado'
        inner join DatosEmpleado e
        on e.DEid = convert(numeric,d.llave)
        inner join Empresa f
        on f.Ecodigo = a.Ecodigo
        inner join Empresas g
        on g.Ecodigo = f.Ereferencia
    --where a.acceso = (select max(x.acceso) from aspmonitor..MonProcesos x where x.Usucodigo=a.Usucodigo)
    group by g.Edescripcion,e.DEidentificacion,e.DEnombre,e.DEapellido1,e.DEapellido2,
    a.Usucodigo,a.ip,a.login
    order by g.Edescripcion,e.DEidentificacion,e.DEnombre,e.DEapellido1,e.DEapellido2,
    a.Usucodigo,a.ip,a.login
</cfquery>

<cfif accesos.RecordCount>
	<div class="subTitulo tituloListas"><strong>&Uacute;ltimo Ingreso por Funcionario</strong></div>
	<cfoutput>
        <table width="100%" border="1">
            <tr>
                <td>Empresa</td>
                <td>Identificaci&oacute;n</td>
                <td>Nombre</td>
                <td>Apellido1</td>
                <td>Apellido2</td>
                <td>IP</td>
                <td>Usuario</td>
                <td>Acceso</td> 
                <td>Cantidad</td> 
            </tr>
            <cfloop query="accesos">
                <tr>
                    <td>#accesos.Edescripcion#</td>
                    <td>#accesos.DEidentificacion#</td>
                    <td>#accesos.DEnombre#</td>
                    <td>#accesos.DEapellido1#</td>
                    <td>#accesos.DEapellido2#</td>
                    <td>#accesos.ip#</td>
                    <td>#accesos.login#</td>
                    <td>#accesos.acceso#</td> 
                    <td align="center">#accesos.cantidad#</td> 
                </tr>
            </cfloop>	
        </table>
    </cfoutput>
<cfelse>
	<center>No se registran ingresos.</center>
</cfif>

<cf_web_portlet_end>
<cf_templatefooter>
