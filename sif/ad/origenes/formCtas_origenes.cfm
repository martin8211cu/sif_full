<cfif modo NEQ "ALTA">
 	<cfquery name="rsOrigenC" datasource="#Session.DSN#">
		select Cdescripcion from ConceptoContable 
		where Oorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Oorigen#">
		and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>	
	<cfquery name="rsCtasC" datasource="#Session.DSN#">
		select Cmayor,
			coalesce ((
						select min(cpv.CPVformatoF)
						from CPVigencia cpv
						where cpv.Ecodigo = cm.Ecodigo
						  and cpv.Cmayor = cm.Cmayor
						  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between CPVdesde and CPVhasta
						), Cmascara) as Cmascara,
				Cdescripcion
		from CtasMayor cm
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
		and  Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
	</cfquery>
	<cfquery name="rsCtasM" datasource="#Session.DSN#">
		select OPtablaMayor from OrigenDocumentos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Oorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Oorigen#">
	</cfquery>
	
    <cfquery name="rsSubcuentas" datasource="#session.dsn#">
        select n.PCNid as Nivel, e.PCEdescripcion, d.PCDvalor, d.PCDdescripcion
        from CtasMayor c
        	join PCEMascaras m on m.PCEMid = c.PCEMid
            join PCNivelMascara n on n.PCEMid = c.PCEMid
            join PCECatalogo e on e.PCEcatid = n.PCEcatid
            join PCDCatalogo d on d.PCEcatid = n.PCEcatid
        where c.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cmayor#">
          and m.PCEMplanCtas = 1
          and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
    
	<cfquery datasource="sifcontrol" name="rsTablas">
		select OPtabla
		from OrigenProv 
		where Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Oorigen#">
		order by OPtabla
	</cfquery>	

	<cfquery name="rsNiveles" datasource="#Session.DSN#">
		select OPtabla, OPconst, OPnivel
		from OrigenNivelProv
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Oorigen   =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Oorigen#">
		and Cmayor     = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
		order by OPnivel
	</cfquery>	
	<cfset list_Niveles = ArrayNew(1)>
	<cfset list_NvConst = ArrayNew(1)>
    
    <!--- inicializar arrays para contener valor actual de niveles --->
    <cfloop from="1" to="#Listlen(rsCtasC.Cmascara, '-') - 1#" index="i">
		<cfset ArraySet(list_Niveles, i, i, '')>
        <cfset ArraySet(list_NvConst, i, i, '')>
       </cfloop>

	<!--- Llenar arrays de niveles --->
	<cfif rsNiveles.recordcount gt 0>
		<cfloop query="rsNiveles">
			<cfset ArraySet( list_Niveles , rsNiveles.OPnivel, rsNiveles.OPnivel, rsNiveles.OPtabla )>
            <cfset ArraySet( list_NvConst , rsNiveles.OPnivel, rsNiveles.OPnivel, rsNiveles.OPconst )>
		</cfloop>
	</cfif>
<cfelse>
	<cfquery datasource="#Session.DSN#" name="rsCtas">
		select Cmayor,coalesce (
			(
						select min(cpv.CPVformatoF)
						from CPVigencia cpv
						where cpv.Ecodigo = cm.Ecodigo
						  and cpv.Cmayor = cm.Cmayor
						  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between CPVdesde and CPVhasta
						), Cmascara) as Cmascara
		,Cdescripcion from CtasMayor cm
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
		and  Cmayor not in (select Cmayor from OrigenCtaMayor
				where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and    Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Oorigen#">
		 )	
		order by Cmayor
	</cfquery>
</cfif>

<form method="post" name="form1"  action="SQLCtas_origenes.cfm">
	<cfif modo EQ "ALTA">
		<table align="center">
			<!--- ***************************************************************************** --->
			<tr valign="baseline"> 
				<td nowrap align="right">Cuenta Mayor :&nbsp;</td>
				<td>
                  <select name="Cmayor" >
                    <cfoutput query="rsCtas">
                      <option value="#rsCtas.Cmayor#">#rsCtas.Cmayor#&nbsp;&nbsp;#rsCtas.Cmascara#&nbsp;&nbsp;#rsCtas.Cdescripcion#</option>
                    </cfoutput>
                  </select>
</td>
			</tr>
			<!--- ***************************************************************************** --->
			<tr valign="baseline"> 
				<td colspan="2" align="center">
                <cfoutput>
					<input type="submit" name="Alta" 	value="Agregar">
					<input type="button" name="lista" 	    value="Regresar" onClick="javascript: location.href = 'lista_origenes.cfm?Oorigen=#Form.Oorigen#&modo=Cambio';">
		<input type="hidden" name="Oorigen" value="#Form.Oorigen#">
                    </cfoutput>
				</td>
			</tr>
		</table>
	<cfelse>
		<table align="center">
			<!--- ***************************************************************************** --->
			<tr valign="baseline"> 
				<td nowrap align="left">Origen:&nbsp;</td>
				<td>
                <cfoutput><strong>#rsOrigenC.Cdescripcion#</strong></cfoutput>
				</td>
			</tr>
			<!--- ***************************************************************************** --->
			<tr valign="baseline"> 
				<td nowrap align="left">Cuenta Mayor:&nbsp;</td>
				<td>
				<cfoutput><strong>#Form.Cmayor#</strong></cfoutput>
				</td>
			</tr>
			<!--- ***************************************************************************** --->
			<tr valign="baseline"> 
				<td nowrap align="left">Mascara:&nbsp;</td>
				<td>
				<cfoutput><strong>#rsCtasC.Cmascara#</strong></cfoutput>
				</td>
			</tr>
			<!--- ***************************************************************************** --->
			<tr valign="baseline"> 
				<td nowrap align="left">Descripci&oacute;n:&nbsp;</td>
				<td>
				<cfoutput><strong>#rsCtasC.Cdescripcion#</strong></cfoutput>
				</td>
			</tr>
			<!--- ***************************************************************************** --->
			<tr valign="baseline"> 
			  <td nowrap  colspan="2 "align="center"><hr></td>

			</tr>			
			
			<!--- ***************************************************************************** --->
			<tr valign="baseline"> 
				<td nowrap  colspan="2 "align="center"><font size="2"><strong>Utilizar estas fuentes para la cuenta</strong></font></td>
			</tr>		
			<tr valign="baseline"> 
				<td nowrap  colspan="2 "align="center">&nbsp;</td>
			</tr>						
			<!--- ***************************************************************************** --->
			<tr valign="baseline"> 
				<td nowrap align="left">Cuenta Mayor:&nbsp;</td>
				<td>
				<cfoutput><strong>#rsCtasM.OPtablaMayor#</strong>&nbsp;&nbsp; 
				<a  style="text-decoration:underline;color:blue; " href="javascript: location.href = 'lista_origenes.cfm?Oorigen=#Form.Oorigen#&modo=Cambio'; " >Modificar Fuente</a></cfoutput>
				</td>
			</tr>		
			<!--- ***************************************************************************** --->
			<cfset arreglo      = listtoarray(rsCtasC.Cmascara,"-")>

			<cfset Cant_Niveles = arraylen(arreglo) -1>
			<cfloop from="1" to ="#Cant_Niveles#" index="i">
				<tr valign="baseline"> 
					<td nowrap align="left"><cfoutput>Nivel #i#:&nbsp;</cfoutput></td>
					<td>
						<select name="<cfoutput>OPtablaMayor_#i#</cfoutput>"  style="width:180px">
						<cfquery dbtype="query" name="hayCatalogoContable">
                        	select 1 from rsSubcuentas where Nivel = #i#
                        </cfquery>
                            <cfif hayCatalogoContable.RecordCount is 0>
                            <option value="F">Valor fijo (especificar)</option>
                            <cfelse>
                            <option value="">Seleccione una fuente</option>
                            </cfif>

                          <optgroup label="Seg&uacute;n concepto">
							<cfoutput query="rsTablas">
								<option value="T,#rsTablas.OPtabla#" 
									<cfif modo NEQ "ALTA"  and ArrayLen(list_Niveles)  and list_Niveles[i] EQ rsTablas.OPtabla>selected</cfif>> 
									#rsTablas.OPtabla#
								</option>
							</cfoutput>
		                </optgroup>
                            <cfoutput query="rsSubcuentas" group="Nivel">
                            <cfif rsSubCuentas.Nivel EQ i>
                            <optgroup label="#HTMLEditFormat( rsSubcuentas.PCEdescripcion )# (Valor fijo)">
								<cfoutput>
									<cfset descrip = HTMLEditFormat(rsSubcuentas.PCDvalor & " " & rsSubcuentas.PCDdescripcion)>
                                    <option value="C,#rsSubcuentas.PCDvalor#" 
                                    <cfif modo NEQ "ALTA"  and ArrayLen(list_NvConst)  and list_NvConst[i] EQ rsSubCuentas.PCDvalor>selected</cfif>> 
                                    #descrip#</option>
                                </cfoutput>
                            </optgroup></cfif>
                            </cfoutput>
						</select>
                        
                        <cfif hayCatalogoContable.RecordCount is 0>
                        <cfoutput>
                        <cfset maxlen = Len(ListGetAt(rsCtasC.Cmascara,i+1,'-'))>
                        <input type="text" name="OPconst_#i#" value="#HTMLEditFormat(Trim(list_NvConst[i]))#" 
                        	maxlength="#maxlen#" style="width:80px" 
                            onkeyup="if (this.value.length)document.form1.OPtablaMayor_#i#.selectedIndex = 0;" 
                            onblur="this.value = this.value.replace(/[^0-9]+/,''); if(this.value.length)this.value = '#RepeatString('0',maxlen)#'.substring(0, #maxlen#-this.value.length)  + this.value" />
                        </cfoutput>
                        </cfif>

                        
					</td>
				</tr>
			</cfloop>
			<!--- ***************************************************************************** --->
			<tr valign="baseline"> 
				<td colspan="2" align="center">
                <cfoutput>
					<input type="submit" name="Cambio" 	    value="Modificar">
					<input type="submit" name="Baja" 		value="Borrar" onclick="javascript: if ( confirm('Est seguro(a) de que desea eliminar el registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
					<input type="submit" name="Nuevo" 		value="Nuevo" onClick="javascript: if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
					<input type="button" name="lista" 	    value="Regresar" onClick="javascript: location.href = 'lista_origenes.cfm?Oorigen=#Form.Oorigen#&modo=Cambio';">
		<input type="hidden" name="Oorigen" value="#Form.Oorigen#">
		<input type="hidden" name="Cmayor" value="#Form.Cmayor#">
		<input type="hidden" name="Cant_Niveles" value="#Cant_Niveles#">
                    </cfoutput>
				</td>
			</tr>
		</table>
	</cfif>
</form>

<cf_qforms>
<cfoutput>
<script language="javascript" type="text/javascript">
	
	<cfif modo NEQ "ALTA">
		objForm.Cant_Niveles.required = true;
		objForm.Cant_Niveles.description="Los niveles de la cuenta";	
		objForm.Oorigen.required = true;
		objForm.Oorigen.description="Origen";		
		objForm.Cmayor.required = true;
		objForm.Cmayor.description="Cuenta Mayor";				
		<cfloop from="1" to ="#Cant_Niveles#" index="i">
			objForm.OPtablaMayor_#i#.required = true;
			objForm.OPtablaMayor_#i#.description ="fuente del origen del nivel #i#";	
		</cfloop>
		
		function deshabilitarValidacion(){
			objForm.Cant_Niveles.required = false;
			objForm.Oorigen.required = false;
			objForm.Cmayor.required = false;
			<cfloop from="1" to ="#Cant_Niveles#" index="i">
				objForm.OPtablaMayor_#i#.required = false;
			</cfloop>			
		}
		
		function habilitarValidacion(){
			objForm.Cant_Niveles.required = true;
			objForm.Oorigen.required = true;
			objForm.Cmayor.required = true;
			<cfloop from="1" to ="#Cant_Niveles#" index="i">
				objForm.OPtablaMayor_#i#.required = true;
			</cfloop>			
			
		}	
	</cfif>		
</script>
</cfoutput>