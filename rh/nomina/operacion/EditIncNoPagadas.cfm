<cfif isdefined("url.Iid") and not isdefined("form.Iid")>
	<cfset form.Iid = url.Iid>
</cfif>

<cfif isdefined("Form.accion")and Form.accion eq 'UPDATE'>
	<cftransaction>
	<cfquery name="rsupdate" datasource="#Session.DSN#">
		update Incidencias
		set Ifecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.Ifecha)#">
		where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#">
	</cfquery>
	<cfquery name="rsRespaldo" datasource="#Session.DSN#">
		insert into HIncidencias 
		(	Iid,
			DEid, 
			CIid, 
			CFid, 
			IfechaAnt, 
			Ifecha, 
			Ivalor, 
			Ifechasis, 
			Usucodigo, 
			Ulocalizacion, 
			BMUsucodigo, 
			Iespecial, 
			RCNid, 
			Mcodigo, 
			RHJid, 
			Imonto, 
			Icpespecial, 
			IfechaRebajo, 
			HIEstado, 
			HBMUsucodigo, 
			BMfechaalta)
		select 
			distinct 
			Iid,
			DEid, 
			CIid, 
			CFid, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.Ifecha)#">, 
			Ifecha, 
			Ivalor, 
			Ifechasis, 
			Usucodigo, 
			Ulocalizacion, 
			BMUsucodigo, 
			Iespecial, 
			RCNid, 
			Mcodigo, 
			RHJid, 
			Imonto, 
			Icpespecial, 
			IfechaRebajo, 
			2, 
			<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">, 
			<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">			
		from Incidencias
		where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#">
	</cfquery>
	</cftransaction>
</cfif>

<cfsilent>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Cambio_de_fecha_del_concepto_incidente"
		Default="Cambio de fecha del concepto incidente"
		returnvariable="Cambio_de_fecha_del_concepto_incidente"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Modificar"
		Default="Modificar"
		returnvariable="Modificar"/>  
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Cerrar"
		Default="Cerrar"
		returnvariable="Cerrar"/>                
</cfsilent>        

<cfquery name="rsLista" datasource="#Session.DSN#">		
    select 
        i.Iid,
        c.CIcodigo,
        c.CIdescripcion, 
        case when i.CFid is null then
			'N/A'
        else  
        	{fn concat(cf.CFcodigo,{fn concat(' ',cf.CFdescripcion)})} 
        end as  CFdescripcion,
        i.Ifecha,
        i.Ivalor,
        case c.CItipo  	when 0 then  '<cf_translate  key="LB_Horas">Hora(s)</cf_translate>' 
                        when 1 then  '<cf_translate  key="LB_Dias">D&iacute;a(s)</cf_translate>'
        						else '<cf_translate  key="LB_Monto">Monto(s)</cf_translate>' 
        end as tipo_Ivalor,
        {fn concat({fn concat({fn concat({fn concat({fn concat({fn concat(d.DEidentificacion ,' ' )} ,d.DEnombre )},' ')},d.DEapellido1 )}, ' ' )},d.DEapellido2 )}  as NombreEmp
        
    from Incidencias i
    inner join  CIncidentes c
        on i.CIid = c.CIid
        and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
    inner join DatosEmpleado d
        on i.DEid  = d.DEid 
    left outer join CFuncional cf
		on cf.CFid = i.CFid    
    where  i.Iid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#">
</cfquery>	
<title>
	<cfoutput>#Cambio_de_fecha_del_concepto_incidente#</cfoutput>
</title>
<cf_web_portlet_start titulo="#Cambio_de_fecha_del_concepto_incidente#">
	<cfoutput>
        <form name="form1" method="post" action="EditIncNoPagadas.cfm">
            <table width="100%" border="0" cellpadding="1" cellspacing="1">
                <tr>
                    <td colspan="2"  align="center">&nbsp;</td>
                </tr>
                <tr>
                    <td width="50%" align="right" >
                        <b><cf_translate  key="LB_Empleado">Empleado</cf_translate>:</b>
                    </td>
                    <td width="50%" >#rsLista.NombreEmp#</td>
                </tr> 
                <tr>
                    <td nowrap align="right"><b><cf_translate  key="LB_Concepto_ncidente">Concepto Incidente</cf_translate>:</b></td>
                    <td >#rsLista.CIcodigo# #rsLista.CIdescripcion#</td>
                </tr> 
                <tr>
                    <td align="right"><b>#trim(rsLista.tipo_Ivalor)#:</b></td>
                    <td >#LSNumberFormat(rsLista.Ivalor,',.00')#</td>
                </tr>
                <tr>
                    <td nowrap align="right"><b><cf_translate  key="LB_Centro_Funcional">Centro Funcional</cf_translate>:</b></td>
                    <td >#rsLista.CFdescripcion#</td>
                </tr>
                <tr>
                    <td align="right" ><b><cf_translate  key="LB_Fecha">Fecha</cf_translate>:</b></td>
                    <td ><cf_sifcalendario  name="Ifecha" value="#LSDateFormat(rsLista.Ifecha, "dd/mm/yyyy")#" tabindex="1"></td>
                </tr>  
                <tr>
                    <td colspan="2"  align="center">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2"  align="center">
                        <input  type="submit"   class="btnLimpiar" name="btnLimpiar"  value="#Modificar#" onClick="modificarFecha();">
                        <input  type="button"   class="btnFiltrar" name="btnFiltrar"  value="#Cerrar#" onClick="CerrarVentana();">
                    </td>
                </tr>   
            </table>
            <cfif isdefined("url.Iid") and len(trim(url.Iid))>
                <input type="hidden" name="Iid" value="#url.Iid#">
            </cfif>  
            <input type="hidden" name="accion" value="">       

        </form>
    </cfoutput>
<cf_web_portlet_end>
<script language="JavaScript">
	function modificarFecha(){
		document.form1.accion.value='UPDATE';
		document.form1.submit();
	}
	function CerrarVentana(){
		window.opener.document.location.reload();
		window.close();
	}
</script>	