<cfif form.CSusatabla neq 2>
    <cfquery name="rsEReglas" datasource="#session.DSN#">
        select ERCid, case ERCclase 
                        when 1 then 'Cantidad' 
                        when 2 then 'Código'
                        when 3 then 'Grado'
                        when 4 then 'Puesto'
                        when 5 then 'Suma Fija'
                        end as Clase
        from EReglaComponente a
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
          and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
    </cfquery>
    <cfif isdefined('form.ERCid')>
        <cfquery name="rsDReglas" datasource="#session.DSN#">
            select b.*
            from EReglaComponente a
            inner join DReglaComponente b
                on b.ERCid = a.ERCid
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
              <cfif  LEN(TRIM(form.ERCid))>
              and a.ERCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERCid#">
              </cfif>
            order by DRCdetalle
        </cfquery>
    </cfif>
</cfif>
<form name="formReglas" method="post">
	<input name="ERCid" type="hidden" value="" />
	<input name="DRCid" type="hidden" value="" />
	<input name="CSid" type="hidden" value="<cfoutput>#form.CSid#</cfoutput>" />
	<input name="id" type="hidden" value="<cfoutput>#form.id#</cfoutput>" />
	<input name="sql" type="hidden" value="<cfoutput>#form.sql#</cfoutput>" />
	<input name="CSusatabla" type="hidden" value="<cfoutput>#form.CSusatabla#</cfoutput>" />
	<cfif isdefined('form.formName')>
	<input name="formName" type="hidden" value="<cfoutput>#form.formName#</cfoutput>" />
	</cfif>
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3">
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td class="tituloAlterno">Seleccione el Detalle de la Regla que desea Agregar</td>
				  </tr>
				</table>
			</td>
		</tr>
		<tr>
			<cfif form.CSusatabla neq 2>
			<td align="right"><strong><cf_translate key="LB_ClaseDetalle">Clase del Detalle</cf_translate>:</strong>&nbsp;</td>
        	<td>
                <select name="ERCclase" onChange="javascript:change_Detalle(this, document.formReglas );">
                    <option value="-1" <cfif isdefined('form.ERCclase') and form.ERCclase eq -1>selected</cfif>>Seleccionar</option>
                    <option value="" <cfif isdefined('form.ERCclase') and len(trim(form.ERCclase)) eq 0>selected</cfif>>Todos</option>
                    <cfoutput query="rsEReglas">
                    <option value="#rsEReglas.ERCid#" <cfif isdefined('form.ERCclase') and form.ERCclase eq rsEReglas.ERCid>selected</cfif>>#rsEReglas.Clase#</option>
                    </cfoutput>
                </select>
			</td>
           	</cfif>
            <td <cfif form.CSusatabla eq 2>colspan="3" </cfif>><cf_botones values="Regresar" names="Regresar" formname="formReglas">
            </td>
		</tr>
        <cfif form.CSusatabla neq 2>
			<cfif isdefined('form.ERCid')>
            <tr>
                <td colspan="3">
                    <table width="100%" cellpadding="3" cellspacing="0">
                        <tr class="tituloListas">
                            <td align="center" colspan="2"><strong><cf_translate key="LB_Detalle">Detalle</cf_translate></strong>&nbsp;</td>
                            <td align="right" colspan="2"><strong><cf_translate key="LB_Valor">Valor</cf_translate></strong>&nbsp;</td>
                            <td align="center" colspan="2"><strong><cf_translate key="LB_Metodo">M&eacute;todo</cf_translate></strong>&nbsp;</td>
                        </tr>
            
                        <cfoutput query="rsDReglas" group="DRCid">
                            <tr onclick="javascript:SeleccionaDetalle(#ERCid#,#DRCid#, document.formReglas );" style="cursor:pointer;">
                                <td align="center" colspan="2">#DRCdetalle#</td>
                                <td align="right" colspan="2">#DRCvalor#</td>
                                <td align="center" colspan="2">
                                    <cfif DRCmetodo EQ 'M'><cf_translate key="LB_Monto">Monto</cf_translate><cfelse><cf_translate key="LB_Porcentaje">Porcentaje</cf_translate></cfif>
                                </td>
                            </tr>
                        </cfoutput>
                    </table>
                </td>
            </tr>
            </cfif>
        <cfelse>
        	<tr>
            	<td align="right"><strong>Cantidad a&ntilde;os:&nbsp;</strong></td>
                <td><cf_monto name="agnos" decimales="0"></td>
                <td><cf_botones names="Agregar" values="Agregar" formname="formReglas"></td>
                <input name="Antig" id="Antig" type="hidden" value="true" />
                <cfquery name="rsCategoria" datasource="#session.dsn#">
                    select RHCcodigo
                    from RHSituacionActual sa 
                        inner join RHMaestroPuestoP mpp
                            on mpp.Ecodigo = sa.Ecodigo and mpp.RHMPPid = sa.RHMPPid
                        inner join RHCategoriasPuesto cp
                            on cp.RHMPPid = mpp.RHMPPid and cp.Ecodigo = mpp.Ecodigo
                        inner join RHCategoria c
                            on c.RHCid = cp.RHCid
                    where sa.Ecodigo = #session.Ecodigo# and sa.RHSAid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#">
                </cfquery>
               	<input name="RHCcodigo" type="hidden" value="<cfoutput>#rsCategoria.RHCcodigo#</cfoutput>" />
            </tr>
        </cfif>
	</table>
</form>

<script language="javascript1.2" type="text/javascript">
		function change_Detalle(obj, form){
			form.ERCid.value = obj.value;
			form.submit();
		}
		function SeleccionaDetalle(EID,ID,form){
			form.action = 'ConlisCompSalarial.cfm';
			form.ERCid.value = EID;
			form.DRCid.value = ID;
			form.submit();
		}
		
		function funcRegresar(){
			document.formReglas.CSid.value="";
		}
		
		function funcAgregar(){
			error = "";
			if(trim(document.formReglas.agnos.value).length == 0)
				error = error + " - La cantidad de años es requerida.";
			if(error.length == 0 )
				return true;
			alert("Se presentaron los siguientes errores:\n"+error);
			return false;
		}
		

		
</script>
<cfabort>