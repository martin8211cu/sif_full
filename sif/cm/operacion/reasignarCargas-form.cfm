<cfparam name="lvarProvCorp" 	default="FALSE">
<cfparam name="form.Ecodigo_f" 	default="#session.Ecodigo#">

<!---►►Proveeduría Corporativa◄◄--->
<cfquery name="rsProvCorp" datasource="#session.DSN#">
    select Coalesce(Pvalor, 'N') Pvalor
    from Parametros 
    where Ecodigo = #session.Ecodigo#
      and Pcodigo = 5100
</cfquery>
<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
  <cfset lvarProvCorp = TRUE>
    <cfquery name="rsEProvCorp" datasource="#session.DSN#">
        select EPCid
        from EProveduriaCorporativa
        where Ecodigo 		  = #session.Ecodigo#
          and EPCempresaAdmin = #session.Ecodigo#
    </cfquery>
    <cfif rsEProvCorp.recordcount eq 0>
    	<cfthrow message="El Catálogo de Proveduría Corporativa no se ha configurado">
    </cfif>
    <cfquery name="rsDProvCorp" datasource="#session.DSN#">
        select DPCecodigo as Ecodigo, Edescripcion
        from DProveduriaCorporativa dpc
        	inner join Empresas e
            	on e.Ecodigo = dpc.DPCecodigo
        where dpc.Ecodigo = #session.Ecodigo#
         and dpc.EPCid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsEProvCorp.EPCid)#" list="yes">)
       	union
        select e.Ecodigo, e.Edescripcion
        from Empresas e
        where e.Ecodigo = #session.Ecodigo#
        order by 2
    </cfquery>
</cfif>

<cfif not isdefined("form.comprador")>
	<cfset form.comprador = session.compras.Comprador >
</cfif>

<style type="text/css">
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	
	.iframe {
		border-bottom-style: nome;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
	}
</style>
<cfquery name="dataSolicitudes" datasource="#session.DSN#">
	select 
            a.ESidsolicitud, 
            a.ESnumero, 
            a.ESobservacion, 
            a.CMTScodigo, 
            a.ESfecha
    
    from ESolicitudCompraCM a
        inner join CMTiposSolicitud b
            left join CMEspecializacionComprador x
                on x.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Comprador#">
                and x.CMTScodigo = b.CMTScodigo
                and x.Ecodigo = b.Ecodigo
            on b.Ecodigo = a.Ecodigo
            and b.CMTScodigo = a.CMTScodigo
        
        inner join DSolicitudCompraCM e
            on  e.ESidsolicitud = a.ESidsolicitud
            and e.Ecodigo = a.Ecodigo
            
    where   a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Comprador#">
            and a.ESestado in (20, 40)
            and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo_f#">
            and not exists(select 1
                            from DSProvLineasContrato z
                            where z.DSlinea = e.DSlinea
                                and z.Ecodigo = e.Ecodigo
                                and z.Estado = 0)	
            
            and not exists (select 1 
                            from DRequisicion p
                            where p.DSlinea = e.DSlinea)
            and not exists (select 1
                            from CMLineasProceso x
                                inner join CMProcesoCompra y
                                    on y.CMPid = x.CMPid
                                    and y.CMPestado <> 50 
                                    and y.CMPestado <> 85
                            where x.DSlinea = e.DSlinea)					
            and not exists (select 1
                            from DOrdenCM x
                                inner join EOrdenCM y
                                    on y.EOidorden = x.EOidorden
                                    and y.EOestado <> 60 
                                    and y.EOestado <> 55 
                                    and y.EOestado <> 10  
                                    and y.EOestado <> 70 	
                            where x.DSlinea = e.DSlinea)            
            
            and (e.DScant - e.DScantsurt != 0)  
    group by a.ESidsolicitud, a.ESnumero, a.CMTScodigo, a.ESobservacion,   a.ESfecha      
    order by a.ESnumero
</cfquery>

<cfquery name="dataComprador" datasource="#session.DSN#">
	select CMCid, CMCnombre 
	 from CMCompradores 
	where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	  and CMCestado = 1
</cfquery>

<script type="text/javascript" language="javascript1.2">
	function asignar(value){
		document.form1.ESidsolicitud.value = value;
		document.getElementById("fr").src = 'reasignarComprador.cfm?ESidsolicitud='+value+'&comprador='+document.form1.comprador.value;
		return false;
	}
	function validar(){
		var error = false;
		var msg   = "Se presentaron los siguientes errores:\n"
		if ( document.form1.ESidsolicitud.value == '' ){
			msg += " - Debe seleccionar la Solicitud que desea reasignar.\n"
			error = true;
		}

		if ( document.form1.CMCid.value == ''){
			msg += " - Debe seleccionar el comprador al que se le reasignará la Solicitud.\n"
			error = true;
		}

		if ( error ){
			alert(msg);
			return !error;
		}
		return true;
	}
</script>

<cfoutput>
<form name="form1" method="post" action="reasignarCargas-email.cfm" onSubmit="javascript: return validar();" >
	<input type="hidden" name="CMCid" 		  value="">
	<input type="hidden" name="ESidsolicitud" value="">
    
	<table align="center" border="0">
		<cfif lvarProvCorp>
            <tr>
                <td nowrap><strong>Seleccione una Empresa:</strong></td>
                <td>
                    <select name="Ecodigo_f" style="width: 250px" onChange="document.form1.action='reasignarCargas.cfm'; document.form1.submit();">
                        <cfloop query="rsDProvCorp">
                            <option value="<cfoutput>#rsDProvCorp.Ecodigo#</cfoutput>" <cfif (isdefined('form.Ecodigo_f') and form.Ecodigo_f eq rsDProvCorp.Ecodigo) or (not isdefined('form.Ecodigo_f') and rsDProvCorp.Ecodigo EQ Session.Ecodigo)> selected</cfif>><cfoutput>#rsDProvCorp.Edescripcion#</cfoutput></option>		
                        </cfloop>	
                    </select>
                </td>
            </tr>
		</cfif>
             <tr>
             	<td nowrap><strong>Seleccione un Comprador:</strong></td>
                <td>
                    <select name="comprador" style="width: 250px" onChange="document.form1.action='reasignarCargas.cfm'; document.form1.submit();">
                        <cfloop query="dataComprador">
                            <option value="#dataComprador.CMCid#" <cfif form.comprador eq dataComprador.CMCid>selected</cfif> >#dataComprador.CMCnombre#</option>
                        </cfloop>
                    </select>
                 </td>
               </tr>
	</table>
                
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		
		<tr><td colspan="3">&nbsp;</td></tr>

		<tr>
			<td class="bottomline"><font size="2"><strong>Lista de solicitudes asignadas actualmente:</strong></font></td>
			<td>&nbsp;</td>
			<td class="bottomline"><font size="2"><strong>Reasignar solicitud a:</strong></font></td>
		</tr>
		
		<tr>
			<td width="60%" valign="top">
				<table width="98%" cellpadding="0" cellspacing="0" align="center">
					<tr class="tituloListas">
						<td width="1%" align="center">&nbsp;</td>
						<td nowrap><strong>N&uacute;mero</strong></td>
						<td align="center" nowrap><strong>Fecha</strong></td>
						<td nowrap><strong>Descripci&oacute;n</strong></td>
						<td align="center" nowrap><strong>Tipo Solicitud</strong></td>
					</tr>
					<cfif dataSolicitudes.RecordCount gt 0>
						<cfloop query="dataSolicitudes">
							<tr class="<cfif dataSolicitudes.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
								<td valign="middle" align="center"><input type="checkbox" name="rb" value="#dataSolicitudes.ESidsolicitud#"  onClick="javascript:asignar(this.value);"></td>
								<td valign="middle">#dataSolicitudes.ESnumero#</td>
								<td align="center" valign="middle">#LSDateFormat(dataSolicitudes.ESfecha, 'dd/mm/yyyy')#</td>
								<td valign="middle">#dataSolicitudes.ESobservacion#</td>
								<td valign="middle" align="center">#dataSolicitudes.CMTScodigo#</td>
							</tr>
						</cfloop>
					<cfelse>
						<tr><td colspan="5" align="center"><strong> - No existen solicitudes asignadas a este comprador - </strong></td></tr>
					</cfif>
				</table> 
			</td>
			<td>&nbsp;</td>
			<td width="40%" valign="top" align="center">
				<iframe name="fr" id="fr" src="reasignarComprador.cfm" width="100%" frameborder="0" scrolling="yes"></iframe>
			</td>
		</tr>
		<tr><td colspan="3" align="center">&nbsp;</td></tr>
		<tr><td colspan="3" align="center"><input type="submit" name="Procesar" value="Reasignar" class="btnAplicar"></td></tr>
	</table>
</form>
</cfoutput>