<cfif isdefined("form.RHPTUEid") and len(trim(form.RHPTUEid))>
	<cfset modoE = 'CAMBIO'>
</cfif>

<cfif modoE eq 'CAMBIO'>
    <cfquery name="rsRHPTUE" datasource="#session.DSN#">
        select 
            a.RHPTUEid,
            a.RHPTUEcodigo,
            a.RHPTUEdescripcion,
            a.CIid,
            a.FechaDesde,
            a.FechaHasta,
            a.Ecodigo,
            a.RHPTUEMonto,
            a.RHPTUEDescFaltas,
            a.RHPTUEDescIncapa
        from RHPTUE a
        where a.Ecodigo = #session.Ecodigo#
        and a.RHPTUEid = #form.RHPTUEid#
    </cfquery>
    
    <cfquery name="rsPTU_Generado" datasource="#session.DSN#">
    	select count(1) as cantidad
        from RHPTUEMpleados
        where RHPTUEid = #form.RHPTUEid#
    </cfquery>
    
    <cfquery name="rsPTU_Pagado" datasource="#session.DSN#">
    	select count(1) as cantidad
        from RHPTUE
        where RHPTUEid = #form.RHPTUEid#
        and RHPTUEPagado = 1
    </cfquery>
</cfif>

<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
	select rtrim(Tcodigo) as Tcodigo, Tdescripcion
	from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Tdescripcion
</cfquery>

<cfquery name="rsRegimenVacaciones" datasource="#Session.DSN#">
	select RVid, Descripcion
	from RegimenVacaciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by Descripcion
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion 
	from Oficinas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by Odescripcion
</cfquery>

<cfquery name="rsDeptos" datasource="#Session.DSN#">
	select Dcodigo, Ddescripcion 
	from Departamentos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by Ddescripcion
</cfquery>

<cfquery name="rsJornadas" datasource="#Session.DSN#">
	select 	RHJid, 
			{fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion 
	from RHJornadas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by Descripcion
</cfquery>

<!----================= TRADUCCION ======================----->
<cfinvoke Key="LB_ConceptoDePago" 
	Default="Concepto de Pago" 
    returnvariable="LB_ConceptoDePago" 
    component="sif.Componentes.Translate" 
    method="Translate"/>	
<cfinvoke Key="LB_TITULOCONLISCONCEPTOSPAGO" 
	Default="Lista de Conceptos de Pago" 
    returnvariable="LB_TITULOCONLISCONCEPTOSPAGO"
    component="sif.Componentes.Translate" 
    method="Translate"/>	

<cfinvoke Key="MSG_NoHayRegistrosRelacionados" 
	Default="No hay registros relacionados" 
    returnvariable="MSG_NoHayRegistrosRelacionados" 
    component="sif.Componentes.Translate" 
    method="Translate"/>				
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Guardar_y_Continuar"
	Default="Guardar y Continuar"
	returnvariable="BTN_Guardar_y_Continuar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Eliminar"
	Default="Eliminar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Eliminar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Siguiente"
	Default="Siguiente"
	returnvariable="BTN_Siguiente"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta_seguro_de_que_desea_eliminar_el_Calculo_del_PTU"
	Default="¿Está seguro de que desea eliminar el Cálculo del PTU?"	
	returnvariable="LB_Esta_seguro_de_que_desea_eliminar_el_Calculo_del_PTU"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Tipo_de_accion_masiva"
	Default="Tipo de acción masiva"	
	returnvariable="MSG_Tipo_de_accion_masiva"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"	
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"	
	returnvariable="MSG_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Fecha_Rige"
	Default="Fecha Rige"	
	returnvariable="MSG_Fecha_Rige"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Fecha_Vence"
	Default="Fecha Vence"	
	returnvariable="MSG_Fecha_Vence"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Tipo_de_Nomina"
	Default="Tipo de Nómina"	
	returnvariable="MSG_Tipo_de_Nomina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Regimen_de_Vacaciones"
	Default="Régimen de Vacaciones"	
	returnvariable="MSG_Regimen_de_Vacaciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Oficina"
	Default="Oficina"	
	returnvariable="MSG_Oficina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Departamento"
	Default="Departamento"	
	returnvariable="MSG_Departamento"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Puesto"
	Default="Puesto"	
	returnvariable="MSG_Puesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Porcentaje_de_Plaza"
	Default="Porcentaje de Plaza"	
	returnvariable="MSG_Porcentaje_de_Plaza"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Porcentaje_de_Salario_Fijo"
	Default="Porcentaje de Salario Fijo"	
	returnvariable="MSG_Porcentaje_de_Salario_Fijo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Jornada"
	Default="Jornada"	
	returnvariable="MSG_Jornada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Categoria_Puesto"
	Default="Categoría Puesto"	
	returnvariable="MSG_Categoria_Puesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipos_de_Accion_Masiva"
	Default="Tipos de Acci&oacute;n Masiva"	
	returnvariable="LB_Tipos_de_Accion_Masiva"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Monto_de_PTU_a_Distribuir"
	Default="Monto de PTU a Distribuir"	
	returnvariable="LB_Monto_de_PTU_a_Distribuir"/>
	
    
<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="javascript" type="text/javascript">
	function funcbtnEliminar() {
		<cfoutput>
		return (confirm('#LB_Esta_seguro_de_que_desea_eliminar_el_Calculo_del_PTU#'));
		</cfoutput>
	}
</script>

<cfoutput>
	<form name="formE" method="post" style="margin: 0;" action="PTU-sql.cfm">
    	<input name="RHPTUEid" type="hidden" value="<cfif isdefined("form.RHPTUEid")>#form.RHPTUEid#</cfif>" />
        <table width="85%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
          <tr>
            <td height="22" class="fileLabel" nowrap><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
            <td height="22" nowrap>
                <input type="text" name="RHPTUEcodigo" size="10" maxlength="5" value="<cfif modoE EQ "CAMBIO">#HTMLEditFormat(rsRHPTUE.RHPTUEcodigo)#</cfif>"  />
            </td>
          </tr>
          <tr>
            <td height="22" class="fileLabel" nowrap><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></td>
            <td height="22" nowrap>
                <input type="text" name="RHPTUEdescripcion" size="30" maxlength="80" value="<cfif modoE EQ "CAMBIO">#HTMLEditFormat(rsRHPTUE.RHPTUEdescripcion)#</cfif>" />
            </td>
          </tr>
          <tr> 
          	<td width="40%" height="22" class="fileLabel" nowrap>#LB_ConceptoDePago#&nbsp;</td>
            <td height="22" nowrap>
                    <cfset valuesArray = ArrayNew(1)>

                    <cfif modoE EQ "CAMBIO">
                    	<cfquery name="rsConcepto" datasource="#session.DSN#">
                        	select 
                            	CIid, 
                                CIcodigo, 
                                CIdescripcion
                            from CIncidentes
                            where CIid = #rsRHPTUE.CIid#
                            and CItipo = 2
                        </cfquery>
                        
                        <cfif rsConcepto.recordcount eq 0>
                        	<cfthrow message="El concepto de pago fue borrado o no es del tipo 2: Importe">
                        <cfelse>
                        	<cfset ArrayAppend(valuesArray, rsConcepto.CIid)>
							<cfset ArrayAppend(valuesArray, rsConcepto.CIcodigo)>
                            <cfset ArrayAppend(valuesArray, rsConcepto.CIdescripcion)>
                        </cfif>                        
                    </cfif>
                    
                    <cf_conlis 
                        campos="CIid, CIcodigo, CIdescripcion"
                        asignar="CIid, CIcodigo, CIdescripcion"
                        size="0,8,30"
                        desplegables="N,S,S"
                        modificables="N,S,N"						
                        title="#LB_TITULOCONLISCONCEPTOSPAGO#"
                        tabla="CIncidentes a"
                        columnas="CIid, CIcodigo, CIdescripcion, CInegativo"
                        filtro="Ecodigo = #Session.Ecodigo# and CItipo = 2"
                        filtrar_por="CIcodigo,CIdescripcion"
                        desplegar="CIcodigo,CIdescripcion"
                        etiquetas="#LB_CODIGO#,#LB_DESCRIPCION#"
                        formatos="S,S"
                        align="left,left"								
                        asignarFormatos="S,S,S"
                        form="formE"
                        showEmptyListMsg="true"
                        EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
                        valuesArray="#valuesArray#" 					
                    />  	
          	</td>
          </tr>
          <tr>
          	<td height="22" class="fileLabel" nowrap><cf_translate key="LB_Monto_de_PTU_a_Distribuir">Monto de PTU a Distribuir</cf_translate>&nbsp;</td>
            <td height="22" nowrap>
                <!--- <input name="RHPTUEMonto" id="RHPTUEMonto" value="<cfif ModoE eq 'CAMBIO'>#rsRHPTUE.RHPTUEMonto#</cfif>" type="text" /> --->
				<cfset LvarRHPTUEMonto = ''>
                <cfif ModoE eq 'CAMBIO'>
                	<cfset LvarRHPTUEMonto = rsRHPTUE.RHPTUEMonto>
                </cfif>
                <cf_inputNumber name="RHPTUEMonto" value="#LvarRHPTUEMonto#" form="formE" enteros="30" decimales="4" negativos='false'>
            </td>
          </tr>
          <tr>
            <td height="22" class="fileLabel" nowrap><cf_translate key="LB_Fecha_Rige">Fecha Rige</cf_translate></td>
            <td height="22" nowrap>
                <cfset fdesde = "">
                <cfif modoE EQ "CAMBIO">
                    <cfset fdesde = LSDateFormat(rsRHPTUE.FechaDesde, 'dd/mm/yyyy')>
                </cfif>
                <cf_sifcalendario form="formE" name="FechaDesde" value="#fdesde#">
            </td>
          </tr>
          <tr id="trFechaVence">
            <td height="22" class="fileLabel" nowrap><cf_translate key="LB_Fecha_Vence">Fecha Vence</cf_translate></td>
            <td height="22" nowrap>
                <cfset fhasta = "">
                <cfif modoE EQ "CAMBIO">
                    <cfset fhasta = LSDateFormat(rsRHPTUE.FechaHasta , 'dd/mm/yyyy')>
                </cfif>
                <cf_sifcalendario form="formE" name="FechaHasta" value="#fhasta#">
            </td>
          </tr>
          <tr>
          	<td>&nbsp;</td>
            <td><input type="checkbox" name="RHPTUEDescFaltas" value="1" id="RHPTUEDescFaltas" <cfif isdefined("rsRHPTUE") and rsRHPTUE.RHPTUEDescFaltas eq 1>checked="checked"</cfif>/><label for="RHPTUEDescFaltas" >&nbsp;Descontar Faltas</label></td>
          </tr>
          <tr>
          	<td>&nbsp;</td>
            <td><input type="checkbox" name="RHPTUEDescIncapa" value="1" id="RHPTUEDescIncapa" <cfif isdefined("rsRHPTUE") and rsRHPTUE.RHPTUEDescIncapa eq 1>checked="checked"</cfif>/><label for="RHPTUEDescIncapa" >&nbsp;Descontar Incapacidades</label></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" align="center">	
            <cfset LvarExclude= ''>
            <cfif modoE eq 'CAMBIO' and rsPTU_Generado.cantidad gt 0>
	            <cfif rsPTU_Pagado.cantidad gt 0>
                	<cfset LvarExclude= 'Cambio,Baja'>
                <cfelse>
                	<cfset LvarExclude= 'Cambio'>
                </cfif>
			</cfif>
		
                <cf_botones form='formE' modo="#modoE#" include="Regresar" exclude="#LvarExclude#">
            </td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
        </table>
	</form>
</cfoutput>

<cf_qforms form="formE" objForm="objFormE">
<script language="javascript" type="text/javascript">
	function funcAlta(){
		<cfoutput>
			objFormE.CIid.required = true;
			objFormE.CIid.description = "#LB_ConceptoDePago#";
			
			objFormE.RHPTUEcodigo.required = true;
			objFormE.RHPTUEcodigo.description = "#LB_CODIGO#";
			
			objFormE.RHPTUEdescripcion.required = true;
			objFormE.RHPTUEdescripcion.description = "#LB_DESCRIPCION#";

			objFormE.RHPTUEMonto.required = true;
			objFormE.RHPTUEMonto.description = "Monto de PTU a Distribuir";
		
			objFormE.FechaDesde.required = true;
			objFormE.FechaDesde.description = "#LB_FechaDesde#";
		
			objFormE.FechaHasta.required = true;
			objFormE.FechaHasta.description = "#LB_FechaHasta#";
		</cfoutput>
	}
	function funcRegresar(){
		document.formE.action='PTU_Lista.cfm';
		document.formE.submit();
		}
	
</script>