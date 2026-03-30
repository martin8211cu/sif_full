<cfquery name="rsPersonas" datasource="#Session.DSN#">
    select 
		coalesce(pa.TLCDcodigo, 0) as CodigoElectoral,
		case 
			when pa.TLCDcodigo is null
			then
				'No Identificado'
			else
		 		((select min(de.TLCDProvincia || ' ' || de.TLCDCanton || ' ' || de.TLCDDistrito)
				from TLCDistritoE de
				where de.TLCDcodigo = pa.TLCDcodigo
				))
			end
		as DistElectoral, 
		coalesce(pa.TLCPcedula, p.TLCPCampo1 || '-' || p.TLCPcedula) as TLCPcedula,
		case when pa.TLCPsexo = '1' then 'M' else 'F' end as Sexo,
		coalesce(pa.TLCPjunta, '0') as Mesa,
		coalesce(pa.TLCPapellido1 || ' ' || pa.TLCPapellido2 || ' ' || pa.TLCPnombre,  'E-' || p.TLCPapellido1 || ' ' || p.TLCPapellido2 || ' ' || p.TLCPnombre) as Nombre
	from  TLCPersonas p
				left outer join TLCPadronE pa
							on pa.TLCPcedula = p.TLCPcedula
	where p.ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.ETLCid#">
	order by 1,5
</cfquery>

<cfoutput>
	<table width="100%" border="0" cellpadding="2" cellspacing="0">
    	<tr class="style1"  bgcolor="##A9C9CD">
            <td colspan="8" align="center"><b>#rsEmpresa.ETLCpatrono# - #rsEmpresa.ETLCnomPatrono#</b></td>
        </tr>
        <tr class="style1"  bgcolor="##A9C9CD">
            <td colspan="8" align="center"><strong>Lista de Votantes por Empresa</strong></td>
        </tr>
        <!--- --->
		<cfif isdefined("url.Ver") and len(trim(url.Ver))>
        	<cfif rsPersonas.TLCPSincronizado eq 1>
                <tr class="style1"  bgcolor="##A9C9CD">
                    <td colspan="8" align="center"><strong><cf_translate key="LB_Sincronizadas">Sincronizadas</cf_translate></strong></td>
                </tr>
            <cfelse>
                <tr class="style1"  bgcolor="##A9C9CD">
                    <td colspan="8" align="center"><strong><cf_translate key="LB_No Sincronizadas">Sin Sincronizar</cf_translate></strong></td>
                </tr>
            </cfif>
		</cfif> 
</cfoutput>
		<cfif rsPersonas.recordCount GT 0>
			<cfflush interval="128">
			<tr class="style4" bgcolor="#B7D1D5">
				<td>&nbsp;&nbsp;C&eacute;dula</td>
				<td>&nbsp;&nbsp;Nombre</td>
				<td>&nbsp;&nbsp;Sexo</td>
				<td>&nbsp;&nbsp;Mesa</td>
			</tr>
			<cfoutput query="rsPersonas" group="CodigoElectoral">
				<tr class="style4" bgcolor="##E3EDEF">
					<td  colspan="4"><strong>Distrito: #CodigoElectoral# - #DistElectoral#</strong></td>
				</tr>
				<cfoutput>
					<tr class="style6">
						<td>&nbsp;&nbsp;#TLCPcedula#</td>
						<td>&nbsp;&nbsp;#Nombre#</td>
						<td>&nbsp;&nbsp;#Sexo#</td>
						<td>&nbsp;&nbsp;#Mesa#</td>
					</tr>
				</cfoutput>
				<tr style="height:1px">
					<td colspan="4" style="height:1px">&nbsp;</td>
				</tr>
			</cfoutput>
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