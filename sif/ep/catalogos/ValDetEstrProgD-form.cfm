<cfif isdefined("form.ID_DDEstrCtaVal") and len(trim(form.ID_DDEstrCtaVal))>
	<cfset modo4 = 'CAMBIO'>
<cfelse>
	<cfset modo4 = 'ALTA'>
</cfif>

<cfif isdefined("Url.fID_DDEstrCtaVal") and Len(Trim(Url.fID_DDEstrCtaVal))>
	<cfparam name="Form.ID_DDEstrCtaVal" default="#Url.fID_DDEstrCtaVal#">
</cfif>

<cfoutput>
	<form name="formDetEst" method="post" action="ValDetEstrProgD.sql.cfm" style="margin: 0;">
		<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
		  <input type="hidden" name="PageNum_lista" value="#Form.PageNum_lista#" tabindex="-1">
		<cfelseif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
		  <input type="hidden" name="PageNum_lista" value="#Form.PageNum#" tabindex="-1">
		</cfif>
        <cfif isdefined("form.ID_EstrCtaVal") and Len(Trim(form.ID_EstrCtaVal))>
            <input type="hidden" name="ID_EstrCtaVal" value="#form.ID_EstrCtaVal#" tabindex="-1">
        </cfif>
        <cfif isdefined("form.ID_DEstrCtaVal") and Len(Trim(form.ID_DEstrCtaVal))>
            <input type="hidden" name="ID_DEstrCtaVal" value="#form.ID_DEstrCtaVal#" tabindex="-1">
        </cfif>
        <cfif isdefined("form.ID_DDEstrCtaVal") and Len(Trim(form.ID_DDEstrCtaVal))>
            <input type="hidden" name="ID_DDEstrCtaVal" value="#form.ID_DDEstrCtaVal#" tabindex="-1">
        </cfif>

		<input type="hidden" name="ID_Estr" value="#rsTiposRep.ID_Estr#" tabindex="-1">
		<cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
		  <input type="hidden" name="fID_Estr" value="#Form.fID_Estr#" tabindex="-1">
		</cfif>
	    <cfif isdefined("form.ID_EstrCtaVal") and Len(Trim(form.ID_EstrCtaVal))>

		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td colspan="4" style="background-color:##CCCCCC"><strong>Detalle a  los Valores al Plan de Cuenta</strong></td>
		  </tr>
		  <tr>
<!---		  	<td>
            	#form.ID_EstrCtaVal#
            </td>
            <td>
                <cfif isdefined("form.ID_DEstrCtaVal") and Len(Trim(form.ID_DEstrCtaVal))>
            	#form.ID_DEstrCtaVal#  #form.PCEcatidref#
                </cfif>
            </td>
--->
			<td colspan="3">
            	<cfparam name="Form.ID_EstrCtaVal" default="#form.ID_EstrCtaVal#">
            	<cfparam name="Form.PCEcatidref"   default="#form.PCEcatidref#">
				<cfif modo4 Neq "ALTA">
					<cfparam name="form.ID_EstrCtaVal" default="1">
					<cfquery name="rsValoresRef" datasource="#Session.DSN#">
                        select d.PCDcatidref,c.PCDvalor,c.PCDdescripcion,d.SaldoInv
                        from CGDDetEProgVal d
                        	inner join CGEstrProgVal e
                        	on d.ID_EstrCtaVal=e.ID_EstrCtaVal
                            inner join PCDCatalogo c
                            on d.PCDcatidref=c.PCDcatid
                        where d.ID_DDEstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_DDEstrCtaVal#">
					</cfquery>
                <cfelse>
					<cfquery name="rsValoresRef" datasource="#Session.DSN#">
                        select c.PCDcatid as PCDcatidref,c.PCDvalor,c.PCDdescripcion,d.SaldoInv
                            from PCDCatalogo c
							left join(select  d.PCDcatidref,d.SaldoInv
										from CGDDetEProgVal d
										inner join CGEstrProgVal e
                        					on d.ID_EstrCtaVal=e.ID_EstrCtaVal
											and  e.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fID_Estr#">
									) d
								on d.PCDcatidref = c.PCDcatid

                        where c.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatidref#">
							and d.PCDcatidref is null
					</cfquery>
				</cfif>

                <select name="PCDcatidref" tabindex="2"
                onChange="">
                    <cfloop query="rsValoresRef">
                        <option value="#rsValoresRef.PCDcatidref#"
                            <cfif modo4 NEQ "ALTA" or isdefined("form.PCDcatidref")>
                                    <cfif (rsValoresRef.PCDcatidref EQ form.PCDcatidref)>
                                        selected
                                    </cfif>
                            </cfif>>
                            #rsValoresRef.PCDvalor# : #rsValoresRef.PCDdescripcion#
                        </option>
                    </cfloop>
                </select>
			</td>
			<cfif rsValores.SaldoInv NEQ "1">
			<td>
            <strong>#LB_SaldoInvertido#&nbsp;</strong>
            <input type="checkbox" name="chcSaldoInv" id="chcSaldoInv" align="left"
			 <cfif #modo4# neq 'ALTA' and rsValoresRef.SaldoInv EQ "1">checked</cfif>>
             </td>
			</cfif>
		  </tr>
		  <tr>
			<td colspan="4">
				<cfif modo4 NEQ "ALTA">
					<cfif rsValores.SaldoInv NEQ "1">
						<cf_botones values="Eliminar,Nuevo,Modificar" tabindex="2">
					<cfelse>
						<cf_botones values="Eliminar,Nuevo" tabindex="2">
					</cfif>
				<cfelse>
                	<cfif isdefined("form.ID_EstrCtaVal") and Len(Trim(form.ID_EstrCtaVal))>
						<cf_botones values="Agregar" tabindex="2">
                    </cfif>
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td colspan="4">&nbsp;</td>
		  </tr>
		</table>
		</cfif>
	</form>
</cfoutput>

<cf_qforms form="form2" objForm="objForm2">

