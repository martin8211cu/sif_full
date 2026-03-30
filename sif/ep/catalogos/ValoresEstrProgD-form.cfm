<cfif isdefined("form.ID_DEstrCtaVal") and len(trim(form.ID_DEstrCtaVal))>
	<cfset modo3 = 'CAMBIO'>
<cfelse>
	<cfset modo3 = 'ALTA'>
</cfif>

<cfif isdefined("Url.fID_EstrCtaVal") and Len(Trim(Url.fID_EstrCtaVal))>
	<cfparam name="Form.ID_EstrCtaVal" default="#Url.fID_EstrCtaVal#">
</cfif>

<cfoutput>
	<form name="form3" method="post" action="ValoresEstrProgD-sql.cfm" style="margin: 0;">
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
		<input type="hidden" name="ID_Estr" value="#rsTiposRep.ID_Estr#" tabindex="-1">

		<cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
		  <input type="hidden" name="fID_Estr" value="#Form.fID_Estr#" tabindex="-1">
		</cfif>

		<cfset LB_ValoresalPlan = t.Translate('LB_ValoresalPlan','Valores al Plan de Cuenta')>
        <cfset LB_SeleccionarPlan = t.Translate('LB_SeleccionarPlan','Seleccionar un Plan de Cuentas')>
        <cfset LB_SaldoInvertido = t.Translate('LB_SaldoInvertido','Saldo Invertido')>

	    <cfif isdefined("form.ID_EstrCtaVal") and Len(Trim(form.ID_EstrCtaVal))>

		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td colspan ="4" style="background-color:##CCCCCC"><strong>#LB_ValoresalPlan#</strong></td>
		  </tr>
		  <tr>
		  	<td>

            <cfif isdefined("form.ID_EstrCtaVal") and Len(Trim(form.ID_EstrCtaVal))>
            	<cfparam name="Form.ID_EstrCtaVal" default="#form.ID_EstrCtaVal#">
				<cfif modo3 Neq "ALTA">
					<cfparam name="form.ID_EstrCtaVal" default="1">
					<cfquery name="rsValores" datasource="#Session.DSN#">
                        select d.ID_DEstrCtaVal,d.PCDcatid,c.PCDvalor,c.PCDdescripcion,d.SaldoInv
                        from CGDEstrProgVal d
                        	inner join CGEstrProgVal e
                        	on d.ID_EstrCtaVal=e.ID_EstrCtaVal
                            inner join PCDCatalogo c
                            on d.PCDcatid=c.PCDcatid
                        where
                       	d.ID_DEstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_DEstrCtaVal#">
					</cfquery>
                <cfelse>
					<cfquery name="rsValores" datasource="#Session.DSN#">
						<cfif isdefined("Form.chcHijo") and Form.chcHijo >
							select PCDcatid,PCDvalor,PCDdescripcion, 0 as SaldoInv
							from (
								select c.PCDcatid,c.PCDvalor,c.PCDdescripcion,count(cr.PCDcatid) hijos,isnull(count(d.PCEcatid),0) asignados
								from PCDCatalogo c
								inner join PCDCatalogo cr
									on c.PCEcatidref = cr.PCEcatid
								inner join CGEstrProgVal e
									on e.PCEcatid=c.PCEcatid
									and e.ID_EstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_EstrCtaVal#">
								left join(select c.PCEcatid, d.PCDcatidref
											from PCDCatalogo c
											inner join(select  d.PCDcatidref
														from CGDDetEProgVal d
														inner join CGEstrProgVal e
															on d.ID_EstrCtaVal=e.ID_EstrCtaVal
															and  e.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fID_Estr#">
													) d
												on d.PCDcatidref = c.PCDcatid
										) d
									on cr.PCDcatid = d.PCDcatidref
								group by c.PCDcatid,c.PCDvalor,c.PCDdescripcion,cr.PCEcatid
								having count(cr.PCDcatid)>isnull(count(d.PCEcatid),0)
							) universo
							except
							select PCDcatid,PCDvalor,PCDdescripcion, 0 as SaldoInv
							from (
								select c.PCDcatid,c.PCDvalor,c.PCDdescripcion, 0 as SaldoInv
								from PCDCatalogo c
								inner join CGEstrProgVal e
									on e.PCEcatid=c.PCEcatid
								inner join (select d.PCDcatid , e.ID_EstrCtaVal
											from CGEstrProgVal e
											inner join CGDEstrProgVal d
												on e.ID_EstrCtaVal = d.ID_EstrCtaVal
												and e.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fID_Estr#">
										) d
									on c.PCDcatid = d.PCDcatid
									and e.ID_EstrCtaVal = d.ID_EstrCtaVal
								where  e.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_Estr#">
									and e.SoloHijos = 0
							UNION all
								select c.PCDcatid,c.PCDvalor,c.PCDdescripcion, 0 as SaldoInv
								from PCDCatalogo c
								inner join CGEstrProgVal e
									on e.PCEcatid=c.PCEcatid
								inner join (select d.PCDcatid , e.ID_EstrCtaVal
											from CGEstrProgVal e
											inner join CGDEstrProgVal d
												on e.ID_EstrCtaVal = d.ID_EstrCtaVal
												and e.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fID_Estr#">
										) d
									on c.PCDcatid = d.PCDcatid
									and e.ID_EstrCtaVal = d.ID_EstrCtaVal
								where  e.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_Estr#">
									and e.ID_EstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_EstrCtaVal#">
							) eliminar
						<cfelse>

							select c.PCDcatid,c.PCDvalor,c.PCDdescripcion, 0 as SaldoInv,e.ID_EstrCtaVal
							from PCDCatalogo c
							inner join CGEstrProgVal e
								on e.PCEcatid=c.PCEcatid
							left join (select d.PCDcatid , e.ID_EstrCtaVal
										from CGEstrProgVal e
										inner join CGDEstrProgVal d
											on e.ID_EstrCtaVal = d.ID_EstrCtaVal
											and e.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fID_Estr#">
									) d
								on c.PCDcatid = d.PCDcatid
							where  d.PCDcatid is null
								and d.ID_EstrCtaVal is null
								and e.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fID_Estr#">
								and e.ID_EstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ID_EstrCtaVal#">
							order by c.PCDvalor
						</cfif>
					</cfquery>
					<!--- <cf_dump var ="#rsValores#"> --->
				</cfif>
                <select name="PCDcatid" tabindex="2" onChange="">
                    <cfloop query="rsValores">
                        <option value="#rsValores.PCDcatid#"
                            <cfif modo3 NEQ "ALTA" or isdefined("form.PCDcatid")>
                                    <cfif (rsValores.PCDcatid EQ form.PCDcatid)>
                                        selected
                                    </cfif>
                            </cfif>>
                            #rsValores.PCDvalor# : #rsValores.PCDdescripcion#
                        </option>
                    </cfloop>
                </select>
			</td>
			<td>
            <strong>#LB_SaldoInvertido#&nbsp;</strong>
            <input type="checkbox" name="chcSaldoInv" id="chcSaldoInv" align="left"
			 <cfif #modo3# neq 'ALTA' and rsValores.SaldoInv EQ 1>checked</cfif>>
             </td>
            <cfelse>
            	<td><strong>#LB_SeleccionarPlan#</strong></td>
                <input type="hidden" name="Cmayor2" value="" tabindex="-1">
                <input type="hidden" name="Ccuenta2" value="" tabindex="-1">
            </cfif>
		  </tr>
		  <tr>
			<td colspan="4">
				<cfif modo3 NEQ "ALTA">
					<cf_botones values="Eliminar,Nuevo,Modificar" tabindex="2">
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

