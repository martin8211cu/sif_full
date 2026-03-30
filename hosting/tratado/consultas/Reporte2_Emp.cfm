<cfquery name="rsEmpresa" datasource="#session.DSN#">
    select ETLCpatrono,ETLCnomPatrono from EmpresasTLC
    where ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.ETLCid#">
</cfquery>
<cfquery name="rsFormato" datasource="#Session.DSN#">
    select 
        FTLCid,
        ETLCid,
        FTLCcedula,
        FTLCformato,
        FTLCnombreCKC,
        FTLCapellido1CKC,
        FTLCapellido2CKC,
        FTLCopcion1,
        FTLCopcion2,
        FTLCopcion3,
        FTLCopcion4,
        FTLCdescricion1,
        FTLCdescricion2,
        FTLCdescricion3,
        FTLCdescricion4
    from  EmpFormatoTLC	
    where ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.ETLCid#">
</cfquery>
<cfquery name="rsPersonas" datasource="#Session.DSN#">
    select 
        TLCPcedula,
        TLCPnombre,
        TLCPapellido1,
        TLCPapellido2,
        TLCPCampo1,
        TLCPCampo2,
        TLCPCampo3,
        TLCPCampo4,
        TLCPSincronizado 
    from   TLCPersonas	
    where ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.ETLCid#">
    <cfif isdefined("url.Ver") and len(trim(url.Ver))>
    	and TLCPSincronizado = #url.Ver#
    </cfif>
    order by TLCPcedula
</cfquery>


<cfoutput>
    <table width="100%" border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td colspan="8" align="center">&nbsp;</td>
        </tr>
        <tr class="style1">
            <td colspan="8" align="center"><b>#rsEmpresa.ETLCnomPatrono#</b></td>
        </tr>
        <tr class="style1">
            <td colspan="8" align="center"><strong><cf_translate key="LB_CedulaJuridica">C&eacute;dula Jur&iacute;dica</cf_translate>:&nbsp;#rsEmpresa.ETLCpatrono#</strong></td>
        </tr>
        <tr class="style1">
            <td colspan="8" align="center"><strong><cf_translate key="LB_Lista_de_personas_asociadas_a_la_empresa">Lista de personas asociadas a la empresa</cf_translate></strong></td>
        </tr>
        <cfif isdefined("url.Ver") and len(trim(url.Ver))>
        	<cfif rsPersonas.TLCPSincronizado eq 1>
                <tr class="style1">
                    <td colspan="8" align="center"><strong><cf_translate key="LB_Sincronizadas">Sincronizadas</cf_translate></strong></td>
                </tr>
            <cfelse>
                <tr class="style1">
                    <td colspan="8" align="center"><strong><cf_translate key="LB_No Sincronizadas">Sin Sincronizar</cf_translate></strong></td>
                </tr>
            
            </cfif>
		
		</cfif>
        <tr class="style6" bgcolor="##CCCCCC">
            <td><strong><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate></strong></td>
            <cfif isdefined("rsFormato.FTLCnombreCKC") and rsFormato.FTLCnombreCKC eq 1>
				<td><strong><cf_translate key="LB_Nombre">Nombre</cf_translate></strong></td>
			</cfif>
            <cfif isdefined("rsFormato.FTLCapellido1CKC") and rsFormato.FTLCapellido1CKC eq 1>
				<td><strong><cf_translate key="LB_Primer_Apellido">Primer Apellido</cf_translate></strong></td>
			</cfif>
            <cfif isdefined("rsFormato.FTLCapellido2CKC") and rsFormato.FTLCapellido2CKC eq 1>
				<td><strong><cf_translate key="LB_Segundo_Apellido">Segundo Apellido</cf_translate></strong></td>
			</cfif>
            <cfif isdefined("rsFormato.FTLCopcion1") and rsFormato.FTLCopcion1 eq 1>
				<td><strong>#rsFormato.FTLCdescricion1#</strong></td>
			</cfif>
            <cfif isdefined("rsFormato.FTLCopcion2") and rsFormato.FTLCopcion2 eq 1>
				<td><strong>#rsFormato.FTLCdescricion2#</strong></td>
			</cfif>
            <cfif isdefined("rsFormato.FTLCopcion3") and rsFormato.FTLCopcion3 eq 1>
				<td><strong>#rsFormato.FTLCdescricion3#</strong></td>
			</cfif>
            <cfif isdefined("rsFormato.FTLCopcion4") and rsFormato.FTLCopcion4 eq 1>
				<td><strong>#rsFormato.FTLCdescricion4#</strong></td>
			</cfif>
           <cfif isdefined("url.Ver") and len(trim(url.Ver)) eq 0>
                <td><strong><cf_translate key="LB_Sincronizado">Sincronizado</cf_translate></strong></td>
            </cfif>
        </tr>
        <cfif rsPersonas.recordCount GT 0>
        	
            <cfloop query="rsPersonas">
               <tr class="style6">
                <td>#rsPersonas.TLCPcedula#</td>
                <cfif isdefined("rsFormato.FTLCnombreCKC") and rsFormato.FTLCnombreCKC eq 1>
                    <td>#rsPersonas.TLCPnombre#</td>
                </cfif>
                <cfif isdefined("rsFormato.FTLCapellido1CKC") and rsFormato.FTLCapellido1CKC eq 1>
                    <td>#rsPersonas.TLCPapellido1#</td>
                </cfif>
                <cfif isdefined("rsFormato.FTLCapellido2CKC") and rsFormato.FTLCapellido2CKC eq 1>
                    <td>#rsPersonas.TLCPapellido2#</td>
                </cfif>
                <cfif isdefined("rsFormato.FTLCopcion1") and rsFormato.FTLCopcion1 eq 1>
                    <td>#rsPersonas.TLCPCampo1#</td>
                </cfif>
                <cfif isdefined("rsFormato.FTLCopcion2") and rsFormato.FTLCopcion2 eq 1>
                    <td>#rsPersonas.TLCPCampo2#</td>
                </cfif>
                <cfif isdefined("rsFormato.FTLCopcion3") and rsFormato.FTLCopcion3 eq 1>
                    <td>#rsPersonas.TLCPCampo3#</td>
                </cfif>
                <cfif isdefined("rsFormato.FTLCopcion4") and rsFormato.FTLCopcion4 eq 1>
                    <td>#rsPersonas.TLCPCampo4#</td>
                </cfif>            
                <cfif isdefined("url.Ver") and len(trim(url.Ver)) eq 0>
                	<td><cfif rsPersonas.TLCPSincronizado eq 1><cf_translate key="LB_Si">Si</cf_translate><cfelse><cf_translate key="LB_No">No</cf_translate></cfif></td>
                </cfif>    
            	</tr>

            </cfloop>
        <cfelse>
            <tr class="style6">
                <td colspan="8" align="center">-------------------------------<cf_translate key="LB_La_empresa_no_tiene_personas_asociadas">La empresa no tiene personas asociadas</cf_translate>-------------------------------</td>
            </tr>		
		</cfif>
        <tr class="style6">
            <td colspan="8" align="center">&nbsp;</td>
        </tr>
        
        <tr class="style6">
            <td colspan="8" align="center">-------------------------------<cf_translate key="LB_Empresa">&Uacute;ltima L&iacute;nea</cf_translate>-------------------------------</td>
        </tr>
    </table>
</cfoutput>