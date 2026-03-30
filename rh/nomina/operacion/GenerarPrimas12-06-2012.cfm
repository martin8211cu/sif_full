
<cfinvoke Key="MSG_SePpresentaronLosSiguientesErrores" Default="Se presentaron los siguientes errores" returnvariable="MSG_SePpresentaronLosSiguientesErrores" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke Key="MSG_DebeSeleccionarAlMenosUnEmpleado" Default="Debe seleccionar al menos un empleado" returnvariable="MSG_DebeSeleccionarAlMenosUnEmpleado" component="sif.Componentes.Translate" method="Translate"/>

<cfset vDebug = false>

<cfinvoke key="BTN_Consultar" default="Consultar" returnvariable="BTN_Consultar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="BTN_Limpiar" default="Limpiar" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="BTN_Aplicar" default="Aplicar" returnvariable="BTN_Aplicar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>												

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasTolerancia" Default="D&iacute;as de Tolerancia" XmlFile="/rh/generales.xml" returnvariable="LB_DiasTolerancia"/>	

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ConceptoPago" Default="Concepto Pago" XmlFile="/rh/generales.xml" returnvariable="LB_ConceptoPago"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaRige" Default="Fecha Rige" returnvariable="LB_FechaRige"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoNomina" Default="Tipo N&oacute;mina" returnvariable="LB_TipoNomina"/>



<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_GenerarIncidenciaPagoPrimaVacacional" Default="Generar incidencia pago prima vacacional" returnvariable="LB_GenerarIncidenciaPagoPrimaVacacional"/> 

<cf_dbtemp name="tmpPrimas" returnvariable="PrimaVac" datasource="#session.DSN#">
    <cf_dbtempcol name="DEid" 				type="numeric" mandatory="no">
    <cf_dbtempcol name="DEidentificacion"	type="varchar(60)" mandatory="no">
    <cf_dbtempcol name="DEnombre" 			type="varchar(100)" mandatory="no">
    <cf_dbtempcol name="DEapellido1" 		type="varchar(80)" mandatory="no">
    <cf_dbtempcol name="DEapellido2" 		type="varchar(80)" mandatory="no">
    <cf_dbtempcol name="EVmes" 				type="numeric" mandatory="no">
    <cf_dbtempcol name="EVdia" 				type="numeric" mandatory="no">
    <cf_dbtempcol name="EVfantig" 			type="datetime" mandatory="no">
	<cf_dbtempcol name="EVfantig1" 			type="datetime" mandatory="no">
    <cf_dbtempcol name="EVfecha" 			type="datetime" mandatory="no">
    <cf_dbtempcol name="FIncidencia" 		type="datetime" mandatory="no">
    <cf_dbtempcol name="MontoPrima" 		type="money" mandatory="no">
</cf_dbtemp>

<cfif isdefined("form.Consultar")>

	<cfset FInicio 	= CreateDate(mid(#form.FechaDesde#,7,4),mid(#form.FechaDesde#,4,2),mid(#form.FechaDesde#,1,2))>
    <cfset FFin 	= Dateadd('d',#form.DiasT#, #FInicio#)>
    
    <cfset Fdesde 	=  #LSDateformat(FInicio,'dd/mm/yyyy')#>
    <cfset Fhasta 	=  #LSDateformat(FFin,'dd/mm/yyyy')#>
    

    
     <cfquery name="rsEmpleadosPrima" datasource="#Session.DSN#">
      select de.DEid, de.DEidentificacion, de.DEnombre, de.DEapellido1,de.DEapellido2, ev.EVfantig, ev.EVfecha, ev.EVmes, ev.EVdia, 0 as MontoPrima
      	, <cf_dbfunction name="dateadd" args="1,ev.EVfantig,yyyy"> as EVfantig1
		,<cf_dbfunction name="datediff" args=" #LSParseDateTime(Fdesde)#,ev.EVfantig,dd"> as DA
        
        ,<cf_dbfunction name="datediff" args="ev.EVfantig, #LSParseDateTime(Fdesde)#,dd"> as DD
        
        , <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Fdesde)#"> as ffedesde
      
      , case when  <cf_dbfunction name="datediff" args="#LSParseDateTime(Fdesde)#,ev.EVfantig,dd"> < 0 then 
	      (((((<cf_dbfunction name="date_part" args="yyyy, '#Fdesde#'"> + 0) * 100) + 
            	<cf_dbfunction name="date_part"	 args="mm, ev.EVfantig">) * 100) + 
                <cf_dbfunction name="date_part"	 args="dd, ev.EVfantig">)
          else
				(((((<cf_dbfunction name="date_part"	args="yyyy, ev.EVfantig"> + 1  ) * 100) + 
            	<cf_dbfunction name="date_part"	args="mm, ev.EVfantig">) *100) + 
                <cf_dbfunction name="date_part"	args="dd, ev.EVfantig">)
          end as AAntig 
          ,(((<cf_dbfunction name="date_part"	args="yyyy, '#Fdesde#'"> *100) +
    		    <cf_dbfunction name="date_part"	args="mm, '#Fdesde#'">) * 100 +  <cf_dbfunction name="date_part"	args="dd, '#Fdesde#'">)   as desde
	       
            ,  (((<cf_dbfunction name="date_part"	args="yyyy, '#Fhasta#'"> *100) +
    		    <cf_dbfunction name="date_part"	args="mm, '#Fhasta#'">) * 100 +  <cf_dbfunction name="date_part"	args="dd, '#Fhasta#'">) as hasta
 
        from DatosEmpleado de
            inner join EVacacionesEmpleado  ev
                on de.DEid = ev.DEid
           inner join LineaTiempo lt
                on de.DEid = lt.DEid
                 and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Fhasta)#">  between lt.LTdesde and lt.LThasta

        where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
       and  case when  <cf_dbfunction name="datediff" args="#LSParseDateTime(Fdesde)#,ev.EVfantig,dd"> < 0 then 
        
	      (((((<cf_dbfunction name="date_part" args="yyyy, '#Fdesde#'"> + 0) * 100) + 
            	<cf_dbfunction name="date_part"	 args="mm, ev.EVfantig">) * 100) + 
                <cf_dbfunction name="date_part"	 args="dd, ev.EVfantig">)
          else
				(((((<cf_dbfunction name="date_part"	args="yyyy, ev.EVfantig"> + 1  ) * 100) + 
            	<cf_dbfunction name="date_part"	args="mm, ev.EVfantig">) *100) + 
                <cf_dbfunction name="date_part"	args="dd, ev.EVfantig">)
          end between
           (((<cf_dbfunction name="date_part"	args="yyyy, '#Fdesde#'"> *100) +
    		    <cf_dbfunction name="date_part"	args="mm, '#Fdesde#'">) * 100 +  <cf_dbfunction name="date_part"	args="dd, '#Fdesde#'">)  
	        and  (((<cf_dbfunction name="date_part"	args="yyyy, '#Fhasta#'"> *100) +
    		    <cf_dbfunction name="date_part"	args="mm, '#Fhasta#'">) * 100 +  <cf_dbfunction name="date_part"	args="dd, '#Fhasta#'">)
                
                order by AAntig
     </cfquery>
	<!---<cf_dump var="#rsEmpleadosPrima#">--->
    
     <cfloop query="rsEmpleadosPrima">
		<cfset fecha = createdate(mid(#rsEmpleadosPrima.AAntig#,1,4),mid(#rsEmpleadosPrima.AAntig#,5,2),mid(#rsEmpleadosPrima.AAntig#,7,2))>
		<cfquery name="rsinsertsPrima" datasource="#Session.DSN#">
        	insert into #PrimaVac# (DEid, DEidentificacion, DEnombre, DEapellido1, DEapellido2 , EVfantig , EVfecha, EVmes, EVdia,  MontoPrima, FIncidencia,EVfantig1)
            values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpleadosPrima.DEid#">,
                    <cfqueryparam  cfsqltype="cf_sql_varchar" value="#rsEmpleadosPrima.DEidentificacion#">,
                    <cfqueryparam  cfsqltype="cf_sql_varchar" value="#rsEmpleadosPrima.DEnombre#">,
                    <cfqueryparam  cfsqltype="cf_sql_varchar" value="#rsEmpleadosPrima.DEapellido1#">,
                    <cfqueryparam  cfsqltype="cf_sql_varchar" value="#rsEmpleadosPrima.DEapellido2#">,
                   <cfqueryparam  cfsqltype="cf_sql_date" 	value="#rsEmpleadosPrima.EVfantig#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#rsEmpleadosPrima.EVfecha#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpleadosPrima.EVmes#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpleadosPrima.EVdia#">,
                    0,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#fecha#">,
					<cfqueryparam  cfsqltype="cf_sql_date" 	value="#rsEmpleadosPrima.EVfantig1#">)
		</cfquery>              
     </cfloop>
     
    <cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>
   
    <cfquery name="rsEmpleadosPrima" datasource="#Session.DSN#">
        select DEid as Chequeado, DEid, DEidentificacion, <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2"> as Empleado
		, MontoPrima,EVfantig,EVfantig1
        from #PrimaVac# 
        order by <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2">
    </cfquery>  
    <cfloop query="rsEmpleadosPrima">
        <cfquery name="rsConcepto" datasource="#session.DSN#">
            select a.CIid, a.CIdescripcion, coalesce(b.CIcantidad,12) as CIcantidad, b.CIrango, b.CItipo, b.CIdia, b.CImes, b.CIcalculo
                , <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosPrima.DEid#"> as DEid,  0 as MontoIncidencia
            from CIncidentes a
                inner join CIncidentesD b
                    on a.CIid = b.CIid
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
        </cfquery>
       
        
        <cfif isdefined('rsConcepto') and rsConcepto.RecordCount>
            <!--- SE LLAMA A LA CALCULADORA PARA VERIFICAL CUAL ES EL VALOR QUE SE UTILIZA PARA EL CALCULO DEL COMPONENTES --->

            <cfset FVigencia = LSDateFormat(rsEmpleadosPrima.EVfantig1, 'DD/MM/YYYY')>
            <cfset FFin = LSDateFormat(now(), 'DD/MM/YYYY')>
            <cfset current_formulas = rsConcepto.CIcalculo>
            <cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
                                       CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
                                           rsConcepto.CIcantidad,
                                           rsConcepto.CIrango,
                                           rsConcepto.CItipo,
                                           rsConcepto.DEid,
                                           0,	<!---RHJid--->
                                           session.Ecodigo,
                                           0,	<!---RHTid--->
                                           0,	<!---RHAlinea--->
                                           rsConcepto.CIdia,
                                           rsConcepto.CImes,
                                           "",	<!---Tcodigo--->
                                           FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo más pesado--->
                                           'false',	<!---masivo--->
                                           '',	<!---tablaTemporal--->
                                           FindNoCase('DiasRealesCalculoNomina', current_formulas), <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
                                           0, 	<!---cantidad--->
                                           "", 	<!---origen--->
                                           "",	<!---CIsprango--->
                                           0, 	<!---CIspcantidad--->
                                           0, 	<!---CImescompleto--->
                                           rsConcepto.MontoIncidencia
                                           )>
                                           
                                           
                                           
            <cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
            <cfset calc_error = RH_Calculadora.getCalc_error()>
            <cfif Not IsDefined("values")>
                <cfif isdefined("presets_text")>
                    <cfthrow detail="#presets_text & '----' & current_formulas & '-----' & calc_error#">
                <cfelse>
                    <cfthrow detail="#calc_error#" >
                </cfif>
            </cfif>
            <cfset vn_cantidad 	= values.get('cantidad').toString()>
            <cfset vn_importe 	= values.get('importe').toString()>
            <cfset vn_resultado = values.get('resultado').toString()>
        <cfelse>
            <cf_throw message="No hay definido un concepto de pago tipo c&aacute;lculo para el componente #rsConcepto.CIdescripcion#. Proceso Cancelado." errorcode="9003">
        </cfif>
        <cfif vDebug>
            Cantidad:<cfdump var="#vn_cantidad#"> </br>
            Importe:<cfdump var="#vn_importe#"></br>
            Resultado: <cf_dump var="#vn_resultado#"></br>
        </cfif>
        <cfquery name="rsUpdatePrima" datasource="#Session.DSN#">
            update #PrimaVac# set MontoPrima =  #vn_resultado# where #PrimaVac#.DEid = #rsEmpleadosPrima.DEid#
	    </cfquery>  
    </cfloop>
    
    

    <cfquery name="rsEmpleadosPrima" datasource="#Session.DSN#">
        select DEid as Chequeado, DEid, DEidentificacion, <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2"> as Empleado, MontoPrima, FIncidencia
        from #PrimaVac#  
        	where #PrimaVac#.DEid not in (select DEid from Incidencias i
            								where i.CIid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CIid#">
                                            and i.Ifechacontrol = #PrimaVac#.FIncidencia)
                                            
				and #PrimaVac#.DEid not in (select DEid from IncidenciasCalculo ic
            								where ic.CIid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CIid#">
                                            and ic.Ifechacontrol = #PrimaVac#.FIncidencia)
                                            
				and #PrimaVac#.DEid not in (select DEid from HIncidenciasCalculo hic
            								where hic.CIid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CIid#">
                                            and hic.Ifechacontrol = #PrimaVac#.FIncidencia)	                                                                                       
                and MontoPrima > 0
        order by <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2">
        
    </cfquery>  
    
        <cfquery name="rsEmpleadosNoPrima" datasource="#Session.DSN#">
        select DEid as Chequeado, DEid, DEidentificacion, <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2"> as Empleado, MontoPrima, FIncidencia
        from #PrimaVac#  
        	where #PrimaVac#.DEid in (select DEid from Incidencias i
            								where i.CIid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CIid#">
                                            and i.Ifechacontrol = #PrimaVac#.FIncidencia)
                                            
				or #PrimaVac#.DEid  in (select DEid from IncidenciasCalculo ic
            								where ic.CIid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CIid#">
                                            and ic.Ifechacontrol = #PrimaVac#.FIncidencia)
                                            
				or #PrimaVac#.DEid  in (select DEid from HIncidenciasCalculo hic
            								where hic.CIid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CIid#">
                                            and hic.Ifechacontrol = #PrimaVac#.FIncidencia)                                                                                        
                or MontoPrima <= 0
        order by <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2">
    </cfquery> 
</cfif>	

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_GenerarIncidenciaPagoPrimaVacacional#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">		
        <form style="margin:0 " name="form1" method="post" action="" onsubmit="return validar();" ><!----ImpBoletasPago-form.cfm---->
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                <cfoutput>
                    <tr>
                        <td nowrap align="right"> #LB_FechaRige#:</td>
                        <td>
                        <cfif isdefined("form.FechaDesde") and len(trim(form.FechaDesde))>	
                            <cf_sifcalendario form="form1" value="#form.FechaDesde#" name="FechaDesde">
                        <cfelse>
                            <cf_sifcalendario form="form1" name="FechaDesde" >
                        </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap align="right"> #LB_DiasTolerancia#:</td>
                        
                            <td><input 	name="DiasT" 
                            onFocus="this.value=qf(this); this.select();" 
                            onBlur="javascript: fm(this,0);"  
                            onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
                            style="text-align: right;" 
                            type="text" 
                            value=" <cfif isdefined("form.DiasT") and len(trim(form.DiasT))> #form.DiasT# <cfelse> #LSNumberFormat(0,"99")#</cfif>"  
                            size="2" maxlength="2"></td>
                                                                </tr>
                   
                    <tr>
                        <td nowrap align="right">#LB_ConceptoPago#:</td>
                         <td>
                            <cfif isdefined("form.CIid") and len(trim(form.CIid))>
                                <cfquery name="rsIncidencia" datasource="#session.DSN#">
                                    select CIid, CIcodigo, CIdescripcion
                                    from CIncidentes
                                    where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
                                        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                </cfquery>
                                <cf_rhCIncidentes query="#rsIncidencia#" >
                            <cfelse>
                               <cf_rhCIncidentes IncluirTipo="3">

                            </cfif> 		
                       </td>
                    </tr>
                    <tr>
                        <td nowrap align="right"><cf_translate  key="LB_Pagaren">Pagar en</cf_translate> :</td>
                        
                        <td width="238"><input type="radio" name="Tnomina" <cfif isdefined("form.Tnomina") and form.Tnomina EQ 1> checked </cfif> value="1" />
                        <cf_translate  key="RAD_Especial">N&oacute;mina Especial</cf_translate></td>
                        <td width="317"><input type="radio" name="Tnomina" <cfif isdefined("form.Tnomina") and form.Tnomina EQ 2> checked </cfif> value="2" />
                        <cf_translate  key="RAD_Normal">N&oacute;mina Normal</cf_translate></td>
                    </tr>
                </cfoutput>
                
                <tr><td colspan="2">&nbsp;</td></tr>
                <tr>
                    <td colspan="3" align="center">
                        <cfoutput>
                            <input type="submit" name="Consultar" 	class="BtnFiltrar" 	value="#BTN_Consultar#">
                            <input type="reset" name="btnLimpiar" value="#BTN_Limpiar#">
                        </cfoutput>
                        
                        <cfif isdefined("rsEmpleadosPrima") and rsEmpleadosPrima.RecordCount NEQ 0>
                            <cfoutput>
                            <input type="button" name="Imprimir" class="BtnAplicar" value="#BTN_Aplicar#" onclick="javascript: funcInsert();">
                            </cfoutput>
                        </cfif>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>		

                <cfif isdefined("form.Consultar") and isdefined("rsEmpleadosPrima") and rsEmpleadosPrima.recordcount GT 0 >	
                	<tr>
                        <td colspan="3">
                           <strong>Lista de Empleados que aplican al pago del concepto</strong>
                        </td>
                    </tr>							
                    <tr>
                        <td colspan="3">
                            <input id="chkAllItems" type="checkbox" name="chkAllItems" value="1" onclick="javascript: funcChkAll(this);" style="border:none;" checked>
                            <label for="chkAllItems">Chequear/Deschequear todos</label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" align="center">											
                            <div style="width:900;height=350;overflow:auto;vertical-align:text-top;">
                                <cfinvoke component="rh.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
                                    <cfinvokeargument name="query" 			   value="#rsEmpleadosPrima#"/>
                                    <cfinvokeargument name="desplegar"		   value="DEidentificacion, Empleado,FIncidencia, MontoPrima"/>
                                    <cfinvokeargument name="etiquetas" 		   value="Identificaci&oacute;n, Nombre,Fecha Anualidad, Monto Prima"/>
                                    <cfinvokeargument name="formatos" 		   value="V,V,D,M"/>
                                    <cfinvokeargument name="align"		 	   value="left,left,Center,right"/>
                                    <cfinvokeargument name="ajustar" 		   value="N"/>
                                    <cfinvokeargument name="showEmptyListMsg"  value="true"/>
                                    <cfinvokeargument name="maxrows" 		   value="#rsEmpleadosPrima.RecordCount#"/>
                                    <cfinvokeargument name="checkboxes" 	   value="S"/>		
                                    <cfinvokeargument name="keys" 			   value="DEid"/>	
                                    <cfinvokeargument name="checkedcol" 	   value="Chequeado"/>
                                    <cfinvokeargument name="checkbox_function" value="UpdChkAll(this)"/>
                                    <cfinvokeargument name="showLink" 		   value="false"/>
                                </cfinvoke>											
                            </div>
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <cfif isdefined("rsEmpleadosPrima") and rsEmpleadosPrima.RecordCount NEQ 0>
                        <tr>
                            <td colspan="3" align="center">
                                <cfoutput>
                                 <input type="button" name="Imprimir" class="BtnAplicar" value="#BTN_Aplicar#" onclick="javascript: funcInsert();">
                                </cfoutput>
                            </td>		
                        </tr>	
                    </cfif>	
                </cfif>	
                 <cfif isdefined("form.Consultar") and isdefined("rsEmpleadosPrima") and rsEmpleadosPrima.recordcount EQ 0 >	
                        <tr><td colspan="3" align="center">* * * No existen empleados * * *</td></tr>				
                 </cfif>
                 <cfif isdefined("form.Consultar") and isdefined("rsEmpleadosPrima") and rsEmpleadosNoPrima.recordcount GT 0 >	
                 	<tr>
                        <td colspan="3">
                           <strong>Lista de Empleados que No aplican al pago del concepto</strong>
                        </td>
                    </tr>	
                 	<tr>
                        <td colspan="3" align="center">											
                            <div style="width:900;height=350;overflow:auto;vertical-align:text-top;">
                                <cfinvoke component="rh.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
                                    <cfinvokeargument name="query" 			   value="#rsEmpleadosNoPrima#"/>
                                    <cfinvokeargument name="desplegar"		   value="DEidentificacion, Empleado, MontoPrima"/>
                                    <cfinvokeargument name="etiquetas" 		   value="Identificaci&oacute;n, Nombre, Monto Prima"/>
                                    <cfinvokeargument name="formatos" 		   value="V,V,M"/>
                                    <cfinvokeargument name="align"		 	   value="left,left,right"/>
                                    <cfinvokeargument name="ajustar" 		   value="N"/>
                                    <cfinvokeargument name="showEmptyListMsg"  value="true"/>
                                    <cfinvokeargument name="maxrows" 		   value="#rsEmpleadosPrima.RecordCount#"/>
                                    <cfinvokeargument name="keys" 			   value="DEid"/>	
                                    <cfinvokeargument name="showLink" 		   value="false"/>
                                     <cfinvokeargument name="MaxRows" 		   value="20"/>
                                </cfinvoke>											
                            </div>
                        </td>
                    </tr>
                 </cfif>	
                					
            </table>
        </form>
		<cf_qforms> <!--- Siempre debe de ir al final despues del </form> --->
	<cf_web_portlet_end>
<cf_templatefooter>


<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>


<script type="text/javascript" language="javascript1.2">
	<cfoutput>
	
	objForm.FechaDesde.required = true;
	objForm.FechaDesde.description = '#LB_FechaRige#';
	objForm.CIid.required = true;
	objForm.CIid.description = '#LB_ConceptoPago#';
	objForm.Tnomina.required = true;
	objForm.Tnomina.description = '#LB_TipoNomina#';

	
	
	
	function validar(){
		<cfoutput>
		var error = false;
		var mensaje = '#MSG_SePpresentaronLosSiguientesErrores#:\n';
		if (error){
			alert(mensaje);
			return false;								
		}
		</cfoutput>
		return true;
	}

	function funcInsert(){								
		<cfoutput>
		var mensaje = '#MSG_SePpresentaronLosSiguientesErrores#:\n';
		var error = false;
		var sincheck = 0;
		if(validar()){
			//Validar almenos uno chequeado
			var continuar = false;
			if (document.form1.chk) {
				if (document.form1.chk.value) {
					if (!document.form1.chk.disabled){continuar = document.form1.chk.checked;}
				} else {
					for (var k = 0; k < document.form1.chk.length; k++) {
						if (document.form1.chk[k].value) {
							if (!document.form1.chk[k].disabled && document.form1.chk[k].checked){ continuar = true;}
						} else {
							for (var counter = 0; counter < document.filtro.chk[k].length; counter++) {
								if (!document.form1.chk[counter].disabled && document.form1.chk[counter].checked) { continuar = true; break; }
							}
						}
					}
				}
				if (!continuar) {
					mensaje  = mensaje + '#MSG_DebeSeleccionarAlMenosUnEmpleado#\n';
					alert(mensaje);
				}
				else{
					document.form1.action = 'GenerarPrimas-sql.cfm'; 
					document.form1.submit();	
				}
			} 														
			</cfoutput>
		}								
	}
	//CHEQUEAR
	function funcChkAll(c) {
		if (document.form1.chk) {
			if (document.form1.chk.value) {
				if (!document.form1.chk.disabled) { 
					document.form1.chk.checked = c.checked;
					//funcChkSolicitud(document.filtro.chk);
				}
			} else {
				for (var counter = 0; counter < document.form1.chk.length; counter++) {
					if (!document.form1.chk[counter].disabled) {
						document.form1.chk[counter].checked = c.checked;
						//funcChkSolicitud(document.form1.ESidsolicitud[counter]);
					}
				}
			}
		}
	}
	//Deschequear
	function UpdChkAll(c) {												
		var allChecked = true;
		if (!c.checked) {
			allChecked = false;
		} else {
			if (document.form1.chk.value) {
				if (!document.form1.chk.disabled) allChecked = true;
			} else {
				for (var counter = 0; counter < document.form1.chk.length; counter++) {
					if (!document.form1.chk[counter].disabled && !document.form1.chk[counter].checked) {allChecked=false; break;}
				}
			}
		}
		document.form1.chkAllItems.checked = allChecked;								
		//alert(c.value)
	}
	</cfoutput>	
</script>

