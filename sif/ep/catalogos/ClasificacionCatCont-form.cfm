<cfquery name="rsClasCat" datasource="#Session.DSN#">
	select PCEcatidClasificado
	from CGEstrProg
	where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTiposRep.ID_Estr#">
</cfquery>

<cfif isdefined("rsClasCat.PCEcatidClasificado") and rsClasCat.PCEcatidClasificado NEQ 0>
	<cfset modo2 = 'CAMBIO'>
<cfelse>
	<cfset modo2 = 'ALTA'>
</cfif>

<cfquery name="rsCuentaMayor" datasource="#Session.DSN#">
	select CGEPCtaMayor from CGEstrProgCtaM
    where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTiposRep.ID_Estr#">
</cfquery>

<cfquery name="rsForm" datasource="#Session.DSN#">
	select ID_EstrCtaVal, ID_Estr, PCEcatid, EPCPcodigo, EPCPdescripcion 
	from CGEstrProgVal
	where ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTiposRep.ID_Estr#">
	<cfif isdefined("form.ID_EstrCtaVal") and Len(Trim(form.ID_EstrCtaVal))>
		and ID_EstrCtaVal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_EstrCtaVal#">
	</cfif>
</cfquery>

<cfoutput>
	<form name="formA" method="post" action="ClasificacionCatCont-sql.cfm" style="margin: 0;">
		<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>		  
		  <input type="hidden" name="PageNum_lista" value="#Form.PageNum_lista#" tabindex="-1">
		<cfelseif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
		  <input type="hidden" name="PageNum_lista" value="#Form.PageNum#" tabindex="-1">
		</cfif>
		
		<input type="hidden" name="ID_Estr" value="#rsTiposRep.ID_Estr#" tabindex="-1">
		        
		<cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>		  
		  <input type="hidden" name="fID_Estr" value="#Form.fID_Estr#" tabindex="-1">
		</cfif>

		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td style="background-color:##CCCCCC"><strong>Cuenta</strong></td>
		  </tr>
		  <tr>
		  	<td>
<!---            <cfif isdefined("form.ID_EstrCta") and Len(Trim(form.ID_EstrCta))>--->
            <cfif rsCuentaMayor.RecordCount gt 0 >
				<!---<cfif modo2 Neq "ALTA">
					<cfparam name="form.PCDcatid" default="1">
					<cfquery name="rsValores" datasource="#Session.DSN#">
                        select distinct cg.ID_Estr,m.PCEcatid,b.PCEcodigo,b.PCEdescripcion
                        from CGEstrProgCtaM cg
                        	inner join CtasMayor c
                        	on cg.CGEPCtaMayor=c.Cmayor
                        	inner join PCNivelMascara m 
                            on c.PCEMid=m.PCEMid 
                            inner join CGEstrProgVal cv
                            on cg.ID_Estr=cv.ID_Estr
                            left outer join PCECatalogo b
                                on b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
                                and b.PCEcatid = m.PCEcatid
                        where
							 cv.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_Estr#">
							 and PCEcodigo is not NULL
					</cfquery>
                <cfelse>--->
					<cfquery name="rsValores" datasource="#Session.DSN#">
                        select distinct cg.ID_Estr,m.PCEcatid,b.PCEcodigo,b.PCEdescripcion
                            from CGEstrProgCtaM cg
                            inner join CtasMayor c
                            on cg.CGEPCtaMayor=c.Cmayor
                            inner join PCNivelMascara m on c.PCEMid=m.PCEMid 
                            left outer join PCECatalogo b
                            on b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
                            and b.PCEcatid = m.PCEcatid
                        where m.PCEcatid <> 0
                        and cg.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTiposRep.ID_Estr#"> 
                    </cfquery>
			<!---	</cfif>--->
				<strong>Plan Contable:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<select name="PCEcatid" tabindex="2" 
                onChange="<!---javascript:this.form.action='ConfiguraEvento.cfm?ID_Event=#form.ID_Evento#';this.form.submit();--->">
                    <!---<option value="XXXX" selected="selected">Seleccionar Plan de Cuenta</option>--->
					<option value="0"> SIN DEFINIR
                    <cfloop query="rsValores"> 
						<option value="#rsValores.PCEcatid#"
                            <cfif modo2 NEQ "ALTA" or isdefined("form.PCEcatid")> 
                                    <cfif (rsValores.PCEcatid EQ rsClasCat.PCEcatidClasificado)>
                                        selected
                                    </cfif>
                            </cfif>>
                            #rsValores.PCEcodigo# : #rsValores.PCEdescripcion#
                        </option>
                    </cfloop> 
                </select>         
            <cfelse>
            		<strong>Capturar cuenta de mayor para la estructura</strong>
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td colspan="4">	
				<!---<cfif modo2 NEQ "ALTA">--->
					<cf_botones values="Guardar" tabindex="2">
				<!---<cfelse>
                	<!---<cfif isdefined("form.ID_EstrCta") and Len(Trim(form.ID_EstrCta))>--->
                    <cfif rsCuentaMayor.RecordCount gt 0 >
						<cf_botones values="Agregar" tabindex="2">
                    </cfif>
				</cfif>	--->		
			</td>
		  </tr>
		  <tr>
			<td colspan="4">&nbsp;</td>
		  </tr>
		</table>
	</form>
</cfoutput>

<cf_qforms form="formA" objForm="objFormA">

