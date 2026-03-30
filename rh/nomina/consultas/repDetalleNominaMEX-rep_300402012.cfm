<!--- Modified with Notepad --->
<cfset Session.DebugInfo = true>
<!--- Pago de Planilla (S.A.) --->
<cfsilent>
	<!--- Invoca el portlet de traduccion y genera algunas 
	variables utilizadas en este componente. --->
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
    
	<!--- Genera variables de traduccion --->
 

	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TituloReporte" Default="Reporte Detalle de Nomina" returnvariable="LB_TituloReporte"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion"		Default="Identificacion" 	returnvariable="LB_Identificacion"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre"		Default="Nombre" 	returnvariable="LB_Nombre"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido1"	Default="Apellido1" returnvariable="LB_Apellido1"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido2"	Default="Apellido2" returnvariable="LB_Apellido2"/>
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SDI"			Default="SDI" 				returnvariable="LB_SDI"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SalDiario"	Default="Salario Diario" 	returnvariable="LB_SalDiario"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Salario"		Default="Salario" 			returnvariable="LB_Salario"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Sueldo"		Default="Sueldo"            returnvariable="LB_Sueldo"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Vales"		Default="Vales Despensa" 	returnvariable="LB_Vales"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetVales"	Default="Ret.Vales Despensa"returnvariable="LB_RetVales"/>
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Subsidio"	Default="Subsidio" 			returnvariable="LB_Subsidio"/>

    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_BonoEmpleado"	Default="Bono Empleado" 	returnvariable="LB_BonoEmpleado"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PieMaquina"		Default="Pie Maquina" 		returnvariable="LB_PieMaquina"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ComisionVentas"	Default="Comision Ventas" 	returnvariable="LB_ComisionVentas"/>
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalHExtrasDobleExc"	Default="HExt Dobles Exc" 	returnvariable="LB_TotalHExtrasDobleExc"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalHExtrasDobleGrv"	Default="HExt Dobles Grv" 	returnvariable="LB_TotalHExtrasDobleGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MtoExtDoblesExc"			Default="Mto HExt Dobles Exc" returnvariable="LB_MtoExtDoblesExc"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MtoExtDoblesGrv"			Default="Mto HExt Dobles Grv" returnvariable="LB_MtoExtDoblesGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalHExtrasTrip"		Default="HExt Triples" 		returnvariable="LB_TotalHExtrasTrip"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MtoExtTriples"			Default="Mto HExt Triples" 	returnvariable="LB_MtoExtTriples"/>
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PrimaDomGrv"	Default="Prima Dom Grv" returnvariable="LB_PrimaDomGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PrimaDomExc"	Default="Prima Dom Exc" returnvariable="LB_PrimaDomExc"/>   
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PreAsist"	Default="Premios de Asistencia" returnvariable="LB_PreAsist"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PrePunt"	Default="Premios de Puntualidad" returnvariable="LB_PrePunt"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Vac0910"	Default="Vacaciones 2009-2010" returnvariable="LB_Vac0910"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Vac1011"	Default="Vacaciones 2010-2011" returnvariable="LB_Vac1011"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Vac1112"	Default="Vacaciones 2011-2012" returnvariable="LB_Vac1112"/>  
     
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RPAguiFin"	Default="Retro Prop Aguinaldo Finiquito" returnvariable="LB_RPAguiFin"/>  
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RPVacFin"	Default="Retro Prop Vacaciones Finiquito" returnvariable="LB_RPVacFin"/>  
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RPPVacFin"	Default="Retro Prop Prima Vacacional Finiquito" returnvariable="LB_RPPVacFin"/>  
    
     
    
      
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PrimaVacGrv"	Default="Prima Vac Grv" returnvariable="LB_PrimaVacGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PrimaVacExc"	Default="Prima Vac Exc" returnvariable="LB_PrimaVacExc"/> 
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescLabo"	Default="Descanso Laborado" 			returnvariable="LB_DescLabo"/> 
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_OtraPrest"	Default="Otras Prestaciones" 			returnvariable="LB_OtraPrest"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FestLab"		Default="Festivo Laboral" 				returnvariable="LB_FestLab"/> 
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetTED"		Default="Retroactivo TED Gravado" 		returnvariable="LB_RetTED"/>   
     <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetTEDEx"	Default="Retro TED Exento"              returnvariable="LB_RetTEDEx"/> 
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetTET"		Default="Retroactivo TET" 				returnvariable="LB_RetTET"/> 
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetPieMaq"	Default="Ret. Pie de Maquina" 			returnvariable="LB_RetPieMaq"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetPrimDom"	Default="Retroactivo P.Dominical Gravada" 		returnvariable="LB_RetPrimDom"/> 
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetPrimDomE"	Default="Retroactivo Prima Dominical (E)" returnvariable="LB_RetPrimDomE"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetDiaFest"	Default="Retroactivo Dia Festivo" 		returnvariable="LB_RetDiaFest"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DevInfona"	Default="Devolucion Credito Infonavit" 	returnvariable="LB_DevInfona"/> 
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DevDtoHer"	Default="Devol. Dscto Herramientas" 	returnvariable="LB_DevDtoHer"/>   

    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Impuntual"	Default="Impuntual" 		returnvariable="LB_Impuntual"/>  
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SalAntic"	Default="Salida Anticipada" returnvariable="LB_SalAntic"/>  
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Retardo"		Default="Retardo" 			returnvariable="LB_Retardo"/>  
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_OtrasDeduc"	Default="Otras Deducciones" returnvariable="LB_OtrasDeduc"/>  
    
    
    
     
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_InfonaSMG"	Default="Infonavit SMG" returnvariable="LB_InfonaSMG"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_InfonaSDI"	Default="Infonavit SDI" returnvariable="LB_InfonaSDI"/>
           

    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PensionAlim"	Default="Pension Alimenticia" 	returnvariable="LB_PensionAlim"/>  
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PrestaPerso"	Default="Prestamo Personal" 	returnvariable="LB_PrestaPerso"/>  
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CuoSindical"	Default="Cuota Sindical"	returnvariable="LB_CuoSindical"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AyuSindical"	Default="Ayuda Sindical" 	returnvariable="LB_AyuSindical"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescSindical"Default="Descuento Sindical"returnvariable="LB_DescSindical"/>   
    
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetSal"		Default="Ret. Salario"				returnvariable="LB_RetSal"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetPreAsist"	Default="Ret. Premio de Asistencia"	returnvariable="LB_RetPreAsist"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetPrePunt"	Default="Ret. Premio de Puntualidad"returnvariable="LB_RetPrePunt"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetVac"		Default="Ret. Vacaciones"			returnvariable="LB_RetVac"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetPrimVac"	Default="Ret. Prima Vac"			returnvariable="LB_RetPrimVac"/>   
    
    
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CargasIMSS"	Default="IMSS" 					returnvariable="LB_CargasIMSS"/>     
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISPT"		Default="ISPT" 					returnvariable="LB_ISPT"/>                 
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetIMSS"		Default="Retroactivo IMSS" 			returnvariable="LB_RetIMSS"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetReteSind"	Default="Ret. Retencion Sindical" 	returnvariable="LB_RetReteSind"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescHerTrab"	Default="Dscto Herramientas de Trab"returnvariable="LB_DescHerTrab"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescEquSeg"	Default="Dscto Equipo de Seguridad" returnvariable="LB_DescEquSeg"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AntiNomin"	Default="Anticipo de Nomina" 		returnvariable="LB_AntiNomin"/>                 

    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasLab"		Default="Dias Trab" 			returnvariable="LB_DiasLab"/>         
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasFalta"	Default="Dias Falta" 			returnvariable="LB_DiasFalta"/>         
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MtoDiasFalta"Default="Mto. Dias Falta" 		returnvariable="LB_MtoDiasFalta"/>         
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasIncap"	Default="Dias Incapacidad" 		returnvariable="LB_DiasIncap"/>                       

	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DiasVac"		Default="Dias Vacacion" 		returnvariable="LB_DiasVac"/>                       
    
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PropAguiExc"	Default="Proporcional Agui Exc" 		returnvariable="LB_PropAguiExc"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PropAguiGrv"	Default="Proporcional Agui Grv" 		returnvariable="LB_PropAguiGrv"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ProPrVacGrv"	Default="Proporcional Prima Vac Grv" 	returnvariable="LB_ProPrVacGrv"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ProPrVacExc"	Default="Proporcional Prima Vac Exc" 	returnvariable="LB_ProPrVacExc"/>   
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ProVacFin"	Default="Proporcion Vac Finiquito" 	returnvariable="LB_ProVacFin"/>   
    
 
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ProDVac"		Default="Proporcional Dias Vacacaiones" returnvariable="LB_ProDVac"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RetPreAgui"	Default="Retroactivo Aguinaldo" 	returnvariable="LB_RetPreAgui"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Indemnizacio"Default="Indemnizacion" 				returnvariable="LB_Indemnizacio"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Separacion"	Default="Separacion" 					returnvariable="LB_Separacion"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PriAntigueda"Default="Primas Antiguiedad"			returnvariable="LB_PriAntigueda"/>   
    
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PTUDias"	Default="PTU en Dias" 		returnvariable="LB_PTUDias"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PTUImp"	Default="PTU Importe" 		returnvariable="LB_PTUImp"/>   
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AguiPag"	Default="Aguinaldo Pagado"	returnvariable="LB_AguiPag"/>   
    

	<!--- Tabla temporal de calendario de pagos --->
	<cf_dbtemp name="calendario" returnvariable="calendario">
		<cf_dbtempcol name="RCNid"   type="int"          mandatory="yes">
		<cf_dbtempcol name="RCdesde" type="datetime"     mandatory="no">
		<cf_dbtempcol name="RChasta" type="datetime"     mandatory="no">
		<cf_dbtempcol name="Tcodigo" type="char(5)"      mandatory="no">
		<cf_dbtempcol name="FechaPago" type="datetime"   mandatory="no">
		<cf_dbtempkey cols="RCNid">
	</cf_dbtemp>
	<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="salida" returnvariable="salida">
		<cf_dbtempcol name="DEid"     		type="int"          mandatory="yes">
        <cf_dbtempcol name="Identificacion"	type="char(50)"     mandatory="no">
        <cf_dbtempcol name="Nombre"   		type="char(100)"     mandatory="no">
        <cf_dbtempcol name="Ape1"   		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="Ape2"   		type="char(80)"     mandatory="no">
        
        <cf_dbtempcol name="CSsalario" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="SalDiario" 		type="money"     	mandatory="no">
        
        <cf_dbtempcol name="Subsidio" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="BonoEmple"		type="money"     	mandatory="no">
        <cf_dbtempcol name="PieMq" 			type="money"       	mandatory="no">
        <cf_dbtempcol name="ComVentas"		type="money"       	mandatory="no">
        <cf_dbtempcol name="THExDobleE"		type="money"       	mandatory="no">
        <cf_dbtempcol name="HExDobleE"		type="money"       	mandatory="no">
        <cf_dbtempcol name="THExDobleG"		type="money"       	mandatory="no">
        <cf_dbtempcol name="HExDobleG"		type="money"       	mandatory="no">
        <cf_dbtempcol name="THExTriple"		type="money"       	mandatory="no">
        <cf_dbtempcol name="HExTriple"		type="money"       	mandatory="no">
        <cf_dbtempcol name="PriDomGrv"		type="money"       	mandatory="no">
        <cf_dbtempcol name="PriDomExc"		type="money"       	mandatory="no">
        <cf_dbtempcol name="PriVacExc" 		type="money"       	mandatory="no">
        <cf_dbtempcol name="PriVacGrv" 		type="money"       	mandatory="no">
        <cf_dbtempcol name="InfonaSMG" 		type="money"       	mandatory="no">
        <cf_dbtempcol name="InfonaSDI" 		type="money"       	mandatory="no">
        <cf_dbtempcol name="PensionAlime" 	type="money"       	mandatory="no">
        <cf_dbtempcol name="PrestPerso" 	type="money"       	mandatory="no">
        <cf_dbtempcol name="CargaIMSS" 		type="money"       	mandatory="no">
        
        <cf_dbtempcol name="Dfaltas" 		type="int"       	mandatory="no">
        <cf_dbtempcol name="MtoDfaltas"		type="money"       	mandatory="no">
        <cf_dbtempcol name="ISPT"			type="money"       	mandatory="no">
        <cf_dbtempcol name="Dincap" 		type="int"       	mandatory="no">
        <cf_dbtempcol name="Dvac" 			type="int"       	mandatory="no">
        <cf_dbtempcol name="DLab" 			type="int"       	mandatory="no">
        <cf_dbtempcol name="Vales" 			type="money"       	mandatory="no">
        
        
        <cf_dbtempcol name="PagAguiExc"		type="money"       	mandatory="no">
        <cf_dbtempcol name="PagAguiGrv"		type="money"       	mandatory="no">
        
        <cf_dbtempcol name="PropAguiExc"	type="money"       	mandatory="no">
        <cf_dbtempcol name="PropAguiGrv"	type="money"       	mandatory="no">
        <cf_dbtempcol name="ProPrVacExc"	type="money"       	mandatory="no">
        <cf_dbtempcol name="ProPrVacGrv"	type="money"       	mandatory="no">
        <cf_dbtempcol name="ProDVac"		type="money"       	mandatory="no">                

        <cf_dbtempcol name="Indemnisacio"	type="money"       	mandatory="no">        
        <cf_dbtempcol name="Separacion"		type="money"       	mandatory="no">        
        <cf_dbtempcol name="PriAntigueda"	type="money"       	mandatory="no">   
        <cf_dbtempcol name="SDI"			type="money"       	mandatory="no">   
        
        <cf_dbtempcol name="Impuntual"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="CuoSindical"	type="money"       	mandatory="no">   
        <cf_dbtempcol name="AyuSindical"    type="money"       	mandatory="no">   
        <cf_dbtempcol name="DescSindical"	type="money"       	mandatory="no">   
        
        
        
		<cf_dbtempcol name="CFcodigo" 		type="char(10)"     mandatory="no">
		<cf_dbtempcol name="CFdescripcion" 	type="char(50)" 	mandatory="no">
		<cf_dbtempcol name="MaxFecha" 		type="datetime"     mandatory="no">
        

        <cf_dbtempcol name="PTUDias"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="PTUImp"			type="money"       	mandatory="no">   
        <cf_dbtempcol name="PreAsist"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="PrePunt"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="ProVacFin"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="OtraPrest"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="FestLab"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="RetSal"			type="money"       	mandatory="no">   
        <cf_dbtempcol name="RetPreAsist"	type="money"       	mandatory="no">   
        <cf_dbtempcol name="RetPrePunt"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="RetPreAgui"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="Vac0910"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="Vac1011"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="Vac1112"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="RetTED"			type="money"       	mandatory="no">   
        <cf_dbtempcol name="RetTET"			type="money"       	mandatory="no">   
        <cf_dbtempcol name="RetVac"			type="money"       	mandatory="no">   
        <cf_dbtempcol name="RetPrimVac"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="RetPieMaq"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="RetValDesp"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="DevInfona"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="DevDtoHer"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="RetPrimDom"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="RetDiaFest"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="DescLabo"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="SalAntic"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="Retardo"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="OtrasDeduc"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="AguiPag"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="RetIMSS"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="RetReteSind"	type="money"       	mandatory="no">   
        <cf_dbtempcol name="DescHerTrab"	type="money"       	mandatory="no">   
        <cf_dbtempcol name="DescEquSeg"		type="money"       	mandatory="no">   
        <cf_dbtempcol name="AntiNomin"		type="money"       	mandatory="no">
        <cf_dbtempcol name="RPAguiFin"		type="money"       	mandatory="no">
        <cf_dbtempcol name="RPVacFin"		type="money"       	mandatory="no">
        <cf_dbtempcol name="RPPVacFin"		type="money"       	mandatory="no">
        <cf_dbtempcol name="RetPrimDomE"	type="money"       	mandatory="no">
        <cf_dbtempcol name="RetTEDEx"		type="money"       	mandatory="no">
        <cf_dbtempcol name="Sueldo"			type="money"       	mandatory="no">   
        
		<cf_dbtempkey cols="DEid">
	</cf_dbtemp>
    
    
    <cfif form.Tfiltro EQ 1>
        
        <!--- Define Form.CPidlist (Puede venir en Form.CPidlist1 o Form.CPidlist2) --->
        <cfif isdefined("form.CPidlist1") and len(trim(form.CPidlist1)) gt 0>
            <cfset form.CPidlist = form.CPidlist1>
        <cfelseif isdefined("form.CPidlist2") and len(trim(form.CPidlist2)) gt 0>
            <cfset form.CPidlist = form.CPidlist2>
        <cfelse>
            <!--- Este error no debe presentarse. --->
            <cfthrow message="Error. Se requiere CPidlist (1 o 2). Proceso Cancelado!">
        </cfif>
        <!--- Obtiene informacion del calendario de pago selecccionado por el usuario. --->
        <cfquery datasource="#session.dsn#">	
            insert #calendario#(RCNid, RCdesde, RChasta, Tcodigo, FechaPago)
                select CPid, CPdesde, CPhasta, Tcodigo, CPfpago
                from CalendarioPagos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    and <cf_whereInList Column="CPid" ValueList="#form.CPidlist#" cfsqltype="cf_sql_numeric">
		</cfquery>
        
    <cfelse>
        <cfquery datasource="#session.dsn#">	
            insert #calendario#(RCNid, RCdesde, RChasta, Tcodigo, FechaPago)
                select CPid, CPdesde, CPhasta, Tcodigo, CPfpago
                from CalendarioPagos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaDesde#">
                   	and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">
                    and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Tcodigo#">
        </cfquery>
	</cfif> 


<cfquery datasource="#session.dsn#" name="rsFechas">
    select min(RCdesde) as finicio  , max(RChasta) as ffinal
    from #calendario#
</cfquery>

<!---<cfdump var="#rsFechas#">
          
 <cf_dumptable var="#calendario#">    --->     
        

       
 <!---====================================
    INSERTA EN LA INFORMACION DE SALIDA, 
    LOS DATOS BASICOS DEL FUNCIONARIO, tomando en cuenta todos los calendarios para el rango de fechas
    ====================================---> 

<cfquery datasource="#session.dsn#" name="rsEmpleados">
	insert #salida# (DEid, Identificacion, Nombre,Ape1,Ape2, CFcodigo, CFdescripcion,CSsalario )
        select distinct a.DEid, a.DEidentificacion, a.DEnombre, a.DEapellido1, a.DEapellido2
                ,f.CFcodigo
                ,f.CFdescripcion
                ,0
        from DatosEmpleado a
            inner join LineaTiempo b
                on a.DEid = b.DEid
            inner join DLineaTiempo d
                on b.LTid = d.LTid
            inner join ComponentesSalariales cs
                on d.CSid = cs.CSid
                    and CSsalariobase = 1
            inner join CalendarioPagos c
                on c.Tcodigo = b.Tcodigo
                    and c.Ecodigo = a.Ecodigo
            inner join RHPlazas p
                on b.RHPid = p.RHPid
            inner join CFuncional f
                on p.CFid = f.CFid
            inner join #calendario# x
                on 	b.Tcodigo = x.Tcodigo
                    and c.CPid = x.RCNid
                    and ((b.LThasta >= x.RCdesde and b.LTdesde <= x.RChasta) or (b.LTdesde <= x.RChasta and b.LThasta >= x.RCdesde))
             
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			<cfif isdefined('form.DEid') and len(trim(form.DEid))> and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> </cfif>
           order by DEid
</cfquery>


<cfif isdefined('form.tiponomina')>
	<cfset vSalarioEmpleado 	= 'HSalarioEmpleado'>
    <cfset vRCalculoNomina 		= 'HRCalculoNomina'>
    <cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
    <cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
    <cfset vPagosEmpleado 		= 'HPagosEmpleado'>
    <cfset vCargasCalculo 		= 'HCargasCalculo'>
<cfelse>	
	<cfset vSalarioEmpleado 	= 'SalarioEmpleado'>
    <cfset vRCalculoNomina 		= 'RCalculoNomina'>
    <cfset vDeduccionesCalculo 	= 'DeduccionesCalculo'>
    <cfset vIncidenciasCalculo 	= 'IncidenciasCalculo'>
    <cfset vPagosEmpleado 		= 'PagosEmpleado'>
    <cfset vCargasCalculo 		= 'CargasCalculo'>
</cfif>

<cfquery datasource="#session.dsn#">
    update #salida# set
        MaxFecha = (Select coalesce(Max(c.RCdesde),getdate())
                from #calendario# a,
                     #vSalarioEmpleado# b,
                     HRCalculoNomina c
                Where b.RCNid=c.RCNid
                and b.DEid=#salida#.DEid
                and b.RCNid=a.RCNid
                )	
</cfquery>


<!---actualiza el valor del subsidio al salario--->
<cfquery datasource="#session.dsn#" name="UpdSubsidio">
    update #salida#
    set Subsidio = 
    coalesce((
    select sum(a.DCvalor)*-1 from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'SubSalario' 	<!---Subsidio al salario MEX--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion de Infonavit SMG--->
<cfquery datasource="#session.dsn#" name="UpdInfonaSMG">
    update #salida#
    set InfonaSMG = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'InfonaSMG' 	<!---Deduccion de Infonavit SMG--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion de Infonavit SDI--->
<cfquery datasource="#session.dsn#" name="UpdInfonaSDI">
    update #salida#
    set InfonaSDI = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'InfonaSDI' 	<!---Infonavit SDI--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion de Pension Alimenticia--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set PensionAlime = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'PensionAlime' 	<!---Deduccion de Pension Alimenticia--->
                            where c.RHRPTNcodigo = 'MX002'					<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion de Cuota Sindical--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set CuoSindical = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'CuoSindical' 		<!---Deduccion de Cuota Sindical--->
                            where c.RHRPTNcodigo = 'MX002'					<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion de Ayuda Sindical--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set AyuSindical = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'AyuSindical' 		<!---Deduccion de Ayuda Sindical--->
                            where c.RHRPTNcodigo = 'MX002'					<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion de Descuento Sindical--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set DescSindical = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'DescSindical' 		<!---Deduccion de Descuento Sindical--->
                            where c.RHRPTNcodigo = 'MX002'					<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion Prestamos Pesonales--->
<cfquery datasource="#session.dsn#" name="UpdPrestPerso">
    update #salida#
    set PrestPerso = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'PrestPerso' 	<!---Deduccion Prestamos Pesonales--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Deduccion Cargas IMSS--->
<cfquery datasource="#session.dsn#" name="UpdCargaIMSSo">
    update #salida#
    set CargaIMSS = 
    coalesce((
    select sum(a.CCvaloremp) from #vCargasCalculo# a, CargasEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.DClinea = b.DClinea
                        and b.DClinea  in (select distinct a.DClinea
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'CargaIMSS' 	<!---Deduccion Cargas IMSS--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Concepto de pago Impuntual--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set Impuntual =  
        	coalesce((
            select coalesce(sum(a.ICmontores),0) 
				    from #vIncidenciasCalculo# a, #calendario# x 
				    where a.DEid = #salida#.DEid 
				    and a.RCNid = x.RCNid 
				    and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'Impuntual'	<!--- Impuntual MEX--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#)
             ),0)
</cfquery>

<!---Bono empleado--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set BonoEmple =  
        	coalesce((
            select coalesce(sum(a.ICmontores),0) 
				    from #vIncidenciasCalculo# a, #calendario# x 
				    where a.DEid = #salida#.DEid 
				    and a.RCNid = x.RCNid 
				    and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'BonEmpleado'	<!---Bono Empleado MEX--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#)
             ),0)
		<!---where exists (
			select 1 
			from #vIncidenciasCalculo# a, #calendario# x 
			where a.DEid = #salida#.DEid 
			and a.RCNid = x.RCNid 
			and CIid  in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'BonEmpleado'	<!---Bono Empleado MEX--->
								where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #session.Ecodigo#))--->
</cfquery>

<!---Pie de Maquina--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PieMq =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PieMaquina'	<!---Pie de Maquina MEX--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Comision sobre ventas MEX--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set ComVentas =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'Comision'	<!---Comision sobre ventas MEX--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Horas Extra Dobles Excentas--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set HExDobleE =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'HExDobleE'	<!---Horas Dobles Excentas--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Total Horas Extra Dobles Excentas--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set THExDobleE =  coalesce((select coalesce(sum(a.ICvalor),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'HExDobleE'	<!---Horas Dobles Excentas--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Horas Extra Dobles Gravables--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set HExDobleG =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'HExDobleG'	<!---Horas Dobles Gravables--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Total Horas Extra Dobles Gravables--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set THExDobleG =  coalesce((select coalesce(sum(a.ICvalor),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'HExDobleG'	<!---Horas Dobles Gravables--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Horas Extra Triples--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set HExTriple =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'HExTriple'	<!---Horas Triples--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Total Horas Extra Triples --->
<cfquery datasource="#session.dsn#">
   update #salida#
		set THExTriple =  coalesce((select coalesce(sum(a.ICvalor),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'HExTriple'	<!---Horas Triples --->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Prima Dominical Excenta--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PriDomExc =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PriDomExc'	<!---Prima Dominical Excenta--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Prima Dominical Gravable--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PriDomGrv =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PriDomGrv'	<!---Prima Dominical Gravable--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---Prima Vacacional Excenta--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PriVacExc =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PriVacExc'	<!---Prima Vacacional Excenta--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Prima Vacacional Gravable--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PriVacGrv =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PriVacGrv'	<!---Prima Vacacional Gravable--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Pago Aguinaldo Excento--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PagAguiExc =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PagAguiExc'	<!---Pago Aguinaldo Excento--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Pago Aguinaldo Gravado--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PagAguiGrv =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PagAguiGrv'	<!---Pago Aguinaldo Gravado--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!--------------------------------------------
conceptos que se pintan en el reporte por que fueron cargados en historico --->

<!---PTU en dias--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PTUDias =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PTUDias'	<!---PTU en dias--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---PTU en Importe--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PTUImp =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PTUImp'	<!---PTU en Importe--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---PREMIOS DE ASISTENCIA--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PreAsist =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PreAsist'	<!---PREMIOS DE ASISTENCIA--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---PREMIOS DE PUNTUALIDAD--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PrePunt =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PrePunt'	<!---PREMIOS DE PUNTUALIDAD--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---PREMIOS DE PUNTUALIDAD--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PrePunt =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PrePunt'	<!---PREMIOS DE PUNTUALIDAD--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---PROPORCION VACACION FINIQUITO--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set ProVacFin =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'ProVacFin'	<!---PROPORCION VACACION FINIQUITO--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---OTRAS PRESTACIONES--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set OtraPrest =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'OtraPrest'	<!---OTRAS PRESTACIONES--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---FESTIVO LABORADO--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set FestLab =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'FestLab'	<!---FESTIVO LABORADO--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---RETROACTIVO SALARIO--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RetSal =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RetSal'		<!---RETROACTIVO SALARIO--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---RETROACTIVO PREMIO DE ASISTENCIA--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RetPreAsist =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RetPreAsist'	<!---RETROACTIVO PREMIO DE ASISTENCIA--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---RETROACTIVO PREMIO DE PUNTUALIDAD--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RetPrePunt =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RetPrePunt'	<!---RETROACTIVO PREMIO DE PUNTUALIDAD--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---RETROACTIVO AGUINALDO--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RetPreAgui =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RetPreAgui'	<!---RETROACTIVO AGUINALDO--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---VACACIONES 2009-2010--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set Vac0910 =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'Vac0910'	<!---VACACIONES 2009-2010--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---VACACIONES 2010-2011--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set Vac1011 =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'Vac1011'		<!---VACACIONES 2010-2011--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---VACACIONES 2011-2012--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set Vac1112 =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'Vac1112'		<!---VACACIONES 2011-2012--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---RETROACTIVO TED--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RetTED =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RetTED'		<!---RETROACTIVO TED--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---RETROACTIVO TET--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RetTET =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RetTET'		<!---RETROACTIVO TET--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---RETROACTIVO VACACIONES--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RetVac =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RetVac'		<!---RETROACTIVO VACACIONES--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---RETROACTIVO PRIM. VAC--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RetPrimVac =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RetPrimVac'	<!---RETROACTIVO PRIM. VAC--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---RETROACTIVO PIE DE MAQUINA--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RetPieMaq =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RetPieMaq'	<!---RETROACTIVO PIE DE MAQUINA--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---RETROACTIVO VALES DESPEN--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RetValDesp =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RetValDesp'	<!---RETROACTIVO VALES DESPEN--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---DEVOLUCION CREDITO INFON--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set DevInfona =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'DevInfona'	<!---DEVOLUCION CREDITO INFON--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---DEVOL DE DSCTO HERRAMIEN--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set DevDtoHer =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'DevDtoHer'	<!---DEVOL DE DSCTO HERRAMIEN--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---RETROACTIVO P. DOMINICAL--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RetPrimDom =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RetPrimDom'	<!---RETROACTIVO P. DOMINICAL--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---RETROACTIVO DIA FESTIVO--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RetDiaFest =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RetDiaFest'	<!---RETROACTIVO DIA FESTIVO--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---DESCANSO LABORADO--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set DescLabo =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'DescLabo'		<!---DESCANSO LABORADO--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!--- Eunice --->
<!---Retroactivo Proporción Aguinaldo Finiquito--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RPAguiFin =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RPAguiFin'	<!---Retroactivo Proporción Aguinaldo Finiquito--->
                                               where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---Retroactivo Proporción Vacaciones Finiquito--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RPVacFin =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RPVacFin'	<!---Retroactivo Proporción Vacaciones Finiquito--->
                                               where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Retroactivo Proporción Prima Vacacional Finiquito--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RPPVacFin =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RPPVacFin'	<!---Retroactivo Proporción Prima Vacacional Finiquito--->
                                               where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Retroactivo Prima Dominical Exenta--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RetPrimDomE =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RetPrimDomE'	<!---Retroactivo Prima Dominical Exenta--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Sueldo--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set Sueldo =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'Sueldo'	<!---Retroactivo Prima Dominical Exenta--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Retroactivo TED Exenta--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set RetTEDEx =  coalesce((select coalesce(sum(a.ICmontores),0) 
                                    from #vIncidenciasCalculo# a, #calendario# x 
                                    where a.DEid = #salida#.DEid 
                                        and a.RCNid = x.RCNid 
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'RetTEDEx'	<!---Retroactivo TED Exenta--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


                                                  
                                          


<!-----------------------------------------
Deducciones Historicas en cargas iniciales
----------------------------------------->

<!---SALIDA ANTICIPADA--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set SalAntic = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'SalAntic' 		<!---SALIDA ANTICIPADA--->
                            where c.RHRPTNcodigo = 'MX002'					<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>


<!---RETARDO--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set Retardo = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'Retardo' 			<!---RETARDO--->
                            where c.RHRPTNcodigo = 'MX002'					<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>


<!---OTRAS DEDUCCIONES--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set OtrasDeduc = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'OtrasDeduc' 		<!---OTRAS DEDUCCIONES--->
                            where c.RHRPTNcodigo = 'MX002'					<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---AGUINALDO PAGADO--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set AguiPag = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'AguiPag' 		<!---AGUINALDO PAGADO--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>


<!---RETROACTIVO IMSS--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set RetIMSS = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'RetIMSS' 		<!---RETROACTIVO IMSS--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---RETROACTIVO RETENCION SINDICAL--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set RetReteSind = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'RetReteSind' 	<!---RETROACTIVO RETENCION SINDICAL--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---DSCTO. HERRAMIENTAS DE TRAB--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set DescHerTrab = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'DescHerTrab' 	<!---DSCTO. HERRAMIENTAS DE TRAB--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---DSCTO. EQUIPO DE SEGURID--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set DescEquSeg = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'DescEquSeg' 	<!---DSCTO. EQUIPO DE SEGURID--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---ANTICIPO DE NOMINA--->
<cfquery datasource="#session.dsn#" name="UpdPensionAlimeo">
    update #salida#
    set AntiNomin = 
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b, #calendario# x
                where a.DEid = #salida#.DEid 
                        and a.RCNid = x.RCNid 
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'AntiNomin' 	<!---ANTICIPO DE NOMINA--->
                            where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>
<!----------------------------------------------->


<!---dias de falta  y el monto por dias falta, Dias de Incapacidad, dias Vacaciones --->
<cfquery datasource="#session.dsn#" name="rsFaltas">
    update #salida#
            <!---Dias de Falta--->
            set Dfaltas = 
                        coalesce(
                        (select sum(pe.PEcantdias)
                        from #vPagosEmpleado# pe
                            inner join  #calendario# x 
                                on pe.RCNid = x.RCNid
                            <!---inner join LineaTiempo lt
                                on pe.LTid = lt.LTid--->
                            inner join  RHTipoAccion ta
                                on pe.RHTid = ta.RHTid
                                    and ta.RHTcomportam = 13
                                where pe.DEid = #salida#.DEid),0)
            <!---Monto Dias de Falta--->
            , MtoDfaltas = 
                        coalesce(
                        (select sum(((coalesce(ta.RHTfactorfalta,1) * (pe.PEsalario / 30))* pe.PEcantdias))
                        from #vPagosEmpleado# pe
                            inner join  #calendario# x 
                                on pe.RCNid = x.RCNid
                            <!---inner join LineaTiempo lt
                                on pe.LTid = lt.LTid--->
                            inner join  RHTipoAccion ta
                                on pe.RHTid = ta.RHTid
                                    and ta.RHTcomportam = 13
                                where pe.DEid = #salida#.DEid),0)
    
             <!---Dias de Incapacidad--->
             , Dincap = 
                                coalesce(
                                (select sum(pe.PEcantdias)
                                from #vPagosEmpleado# pe
                                    inner join  #calendario# x 
                                        on pe.RCNid = x.RCNid
                                    <!---inner join LineaTiempo lt
                                        on pe.LTid = lt.LTid--->
                                    inner join  RHTipoAccion ta
                                        on pe.RHTid = ta.RHTid
                                            and ta.RHTcomportam = 5
                                        where pe.DEid = #salida#.DEid),0)
				<!---Dias de Vacaciones--->
                , Dvac = 
                                coalesce(
                                (select sum(pe.PEcantdias)
                                from #vPagosEmpleado# pe
                                    inner join  #calendario# x 
                                        on pe.RCNid = x.RCNid
                                    <!---inner join LineaTiempo lt
                                        on pe.LTid = lt.LTid--->
                                    inner join  RHTipoAccion ta
                                        on pe.RHTid = ta.RHTid
                                            and ta.RHTcomportam = 3
                                        where pe.DEid = #salida#.DEid),0)     
                , DLab =                      
                             coalesce(
                                (select sum(pe.PEcantdias)
                                from #vPagosEmpleado# pe
                                    inner join  #calendario# x 
                                        on pe.RCNid = x.RCNid
                                   <!--- inner join LineaTiempo lt
                                        on pe.LTid = lt.LTid--->
                                    inner join  RHTipoAccion ta
                                        on pe.RHTid = ta.RHTid
                                            and ta.RHTcomportam not in(3,5,13)
                                        where pe.DEid = #salida#.DEid),0)            
</cfquery>



<!---Renta ISPT--->
<cfquery datasource="#session.dsn#" name="rsISPT">
    update #salida#
            set ISPT = 
                coalesce(
                        (select sum(se.SErenta)
                        from #vSalarioEmpleado# se
                            inner join  #calendario# x 
                                on se.RCNid = x.RCNid
                                where se.DEid = #salida#.DEid),0)
                                
                ,Vales = 
                    coalesce(
                            (select sum(se.SEespecie)
                            from #vSalarioEmpleado# se
                                inner join  #calendario# x 
                                    on se.RCNid = x.RCNid
                                    where se.DEid = #salida#.DEid),0)
                ,CSsalario = 
                        coalesce(
                                (select sum(se.SEsalariobruto)
                                from #vSalarioEmpleado# se
                                    inner join  #calendario# x 
                                        on se.RCNid = x.RCNid
                                        where se.DEid = #salida#.DEid),0)
				,SDI = 
                        coalesce(
                                (select sum(se.SEsalariobc)
                                from #vSalarioEmpleado# se
                                    inner join  #calendario# x 
                                        on se.RCNid = x.RCNid
                                        where se.DEid = #salida#.DEid),0)

</cfquery>

<!---Salario Diario--->

<cfquery datasource="#session.dsn#" name="rsISPT">
    update #salida#
            set SalDiario = CSsalario / DLab
	where DLab > 0
</cfquery>


<!---conceptos de liquidacion --->
<!----
<!---Pago Aguinaldo Excento--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PropAguiExc =  coalesce((select coalesce(sum(a.RHLIexento),0) 
                                        from RHLiqIngresos a 
                                            inner join DLaboralesEmpleado dl
                                                on a.DLlinea = dl.DLlinea
                                            where a.DEid = #salida#.DEid  
                                            and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">  
                                            						and  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PropAguiExc'	<!---Pago Aguinaldo Excento--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---Pago Aguinaldo Gravado--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PropAguiGrv=  coalesce((select coalesce(sum(a.RHLIgrabado),0) 
                                        from RHLiqIngresos a 
                                            inner join DLaboralesEmpleado dl
                                                on a.DLlinea = dl.DLlinea
                                            where a.DEid = #salida#.DEid  
                                            and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">  
                                            						and  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PagAguiGrv'	<!---Pago Aguinaldo Gravado--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>




<!---Proporcional Prima Vacaciones Gravado--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set ProPrVacExc=  coalesce((select coalesce(sum(a.RHLIexento),0) 
                                        from RHLiqIngresos a 
                                            inner join DLaboralesEmpleado dl
                                                on a.DLlinea = dl.DLlinea
                                            where a.DEid = #salida#.DEid  
                                            and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">  
                                            						and  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'ProPrVacExc'	<!---Proporcional Prima Vacaciones Excenta--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Proporcional Prima Vacaciones Gravado--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set ProPrVacGrv=  coalesce((select coalesce(sum(a.RHLIgrabado),0) 
                                        from RHLiqIngresos a 
                                            inner join DLaboralesEmpleado dl
                                                on a.DLlinea = dl.DLlinea
                                            where a.DEid = #salida#.DEid  
                                            and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">  
                                            						and  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'ProPrVacGrv'	<!---Proporcional Prima Vacaciones Gravado--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>



<!---Indemnizacion--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set Indemnisacio=  coalesce((select coalesce(sum(a.importe),0) 
                                        from RHLiqIngresos a 
                                            inner join DLaboralesEmpleado dl
                                                on a.DLlinea = dl.DLlinea
                                            where a.DEid = #salida#.DEid  
                                            and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">  
                                            						and  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'Indemnisacio'	<!---Indemnizacion--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>


<!---Separacion--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set Separacion=  coalesce((select coalesce(sum(a.importe),0) 
                                        from RHLiqIngresos a 
                                            inner join DLaboralesEmpleado dl
                                                on a.DLlinea = dl.DLlinea
                                            where a.DEid = #salida#.DEid  
                                            and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">  
                                            						and  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'Separacion'	<!---Separacion--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Proporcional Prima Antiguedad--->
<cfquery datasource="#session.dsn#">
   update #salida#
		set PriAntigueda=  coalesce((select coalesce(sum(a.importe),0) 
                                        from RHLiqIngresos a 
                                            inner join DLaboralesEmpleado dl
                                                on a.DLlinea = dl.DLlinea
                                            where a.DEid = #salida#.DEid  
                                            and dl.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">  
                                            						and  <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'PriAntigueda'	<!---Proporcional Prima Antiguedad--->
                                                where c.RHRPTNcodigo = 'MX002'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

---->
<!---<cf_dumpTABLE var="#salida#">--->





<!--- Consultas para el Reporte --->
<cfquery name="rsReporte" datasource="#session.dsn#">
	select *
	from #salida#
	order by Ape1,Ape2,Nombre
</cfquery>

</cfsilent>
<cf_htmlReportsHeaders irA="repDetalleNominaMEX-form.cfm"
FileName="Reporte_detalle_Planilla.xls"
title="#LB_TituloReporte#">
<cf_templatecss>
<table width="100%" border="1" cellpadding="0" cellspacing="0" align="center">
<cfoutput>
<tr>
	<td colspan="100%">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>	
				<!---<cfif isdefined('form.tiponomina')>
					<cfinvoke key="LB_IncluyeNominasAplicadas" default="Incluye N&oacute;minas Aplicadas" returnvariable="LB_IncluyeNominasAplicadas" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro3 = LB_IncluyeNominasAplicadas>
				<cfelse>
					<cfinvoke key="LB_IncluyeNominasEnProceso" default="Incluye N&oacute;minas En Proceso" returnvariable="LB_IncluyeNominasEnProceso" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro3 = LB_IncluyeNominasEnProceso>
				</cfif>--->
				<cf_EncReporte
					Titulo="#LB_TituloReporte#"
					Color="##E3EDEF"
					filtro1="#form.TDescripcion2#"
					filtro2="Desde:#lsdateformat(rsFechas.finicio,'dd/mm/yyyy')# al #lsdateformat(rsFechas.ffinal,'dd/mm/yyyy')#"
				>
			</td>
		</tr>
		</table>
	</td>
 </tr>
    <td  class="tituloListas" valign="top"><strong>#LB_Identificacion#</strong>&nbsp;&nbsp;</td> 
    <td  class="tituloListas" valign="top"><strong>#LB_Apellido1#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_Apellido2#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong>&nbsp;&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DiasLab#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DiasFalta#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_MtoDiasFalta#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DiasIncap#</strong>&nbsp;</td>
    
    
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_SalDiario#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Salario#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Sueldo#</strong>&nbsp;</td>
    

    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Vales#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetVales#</strong>&nbsp;</td>
    
    
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_SDI#</strong>&nbsp;</td>
    
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Subsidio#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_BonoEmpleado#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PieMaquina#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ComisionVentas#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalHExtrasDobleExc#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_MtoExtDoblesExc#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalHExtrasDobleGrv#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_MtoExtDoblesGrv#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalHExtrasTrip#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_MtoExtTriples#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PrimaDomGrv#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PrimaDomExc#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PreAsist#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PrePunt#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Vac0910#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Vac1011#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Vac1112#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PrimaVacGrv#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PrimaVacExc#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DescLabo#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_OtraPrest#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_FestLab#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetTED#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetTEDEx#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetTET#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetPieMaq#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetPrimDom#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetPrimDomE#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetDiaFest#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RPAguiFin#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RPVacFin#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RPPVacFin#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DevInfona#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DevDtoHer#</strong>&nbsp;</td>
    
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Impuntual#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_SalAntic#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Retardo#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_OtrasDeduc#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_InfonaSMG#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_InfonaSDI#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PensionAlim#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PrestaPerso#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_CuoSindical#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_AyuSindical#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DescSindical#</strong>&nbsp;</td>
    
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetSal#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetPreAsist#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetPrePunt#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetVac#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetPrimVac#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_CargasIMSS#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ISPT#</strong>&nbsp;</td>
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetIMSS#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetReteSind#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DescHerTrab#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DescEquSeg#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_AntiNomin#</strong>&nbsp;</td>
    
    
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_DiasVac#</strong>&nbsp;</td>    
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PropAguiExc#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PropAguiGrv#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ProPrVacGrv#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ProPrVacExc#</strong>&nbsp;</td>    
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ProVacFin#</strong>&nbsp;</td>    

    <td  class="tituloListas" valign="top" align="right"><strong>#LB_ProDVac#</strong>&nbsp;</td>  
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_RetPreAgui#</strong>&nbsp;</td>    
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Indemnizacio#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_Separacion#</strong>&nbsp;</td>    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PriAntigueda#</strong>&nbsp;</td>  
    
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PTUDias#</strong>&nbsp;</td>  
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_PTUImp#</strong>&nbsp;</td>  
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_AguiPag#</strong>&nbsp;</td>  

</tr>
</cfoutput>


<cfoutput query="rsReporte" group="CFdescripcion">


	<cfoutput>
		<tr class="<cfif rsReporte.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td nowrap>#rsReporte.Identificacion#</td>
            <td nowrap>#rsReporte.Ape1#</td>
            <td nowrap>#rsReporte.Ape2#</td>
            <td nowrap>#rsReporte.Nombre#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.DLab,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Dfaltas,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.MtoDfaltas,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Dincap,'none')#</td>
            
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.SalDiario,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.CSsalario,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Sueldo,'none')#</td>
            
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Vales,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetValDesp,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.SDI,'none')#</td>
            
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Subsidio,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.BonoEmple,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PieMq,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ComVentas,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.THExDobleE,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.HExDobleE,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.THExDobleG,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.HExDobleG,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.THExTriple,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.HExTriple,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriDomGrv,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriDomExc,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PreAsist,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PrePunt,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Vac0910,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Vac1011,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Vac1112,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriVacGrv,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriVacExc,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.DescLabo,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.OtraPrest,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.FestLab,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetTED,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetTEDEx,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetTET,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetPieMaq,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetPrimDom,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetPrimDomE,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetDiaFest,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RPAguiFin,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RPVacFin,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RPPVacFin,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.DevInfona,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.DevDtoHer,'none')#</td>
           
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Impuntual,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.SalAntic,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Retardo,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.OtrasDeduc,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.InfonaSMG,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.InfonaSDI,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PensionAlime,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PrestPerso,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.CuoSindical,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.AyuSindical,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.DescSindical,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetSal,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetPreAsist,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetPrePunt,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetVac,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetPrimVac,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.CargaIMSS,'none')#</td>
            

            <td nowrap align="right">#LSCurrencyformat(rsReporte.ISPT,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetIMSS,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetReteSind,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.DescHerTrab,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.DescEquSeg,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.AntiNomin,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Dvac,'none')#</td>
            
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PropAguiExc,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PropAguiGrv,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ProPrVacGrv,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ProPrVacExc,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ProVacFin,'none')#</td>            
                
            <td nowrap align="right">#LSCurrencyformat(rsReporte.ProDVac,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.RetPreAgui,'none')#</td>
            
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Indemnisacio,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.Separacion,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PriAntigueda,'none')#</td>

            <td nowrap align="right">#LSCurrencyformat(rsReporte.PTUDias,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.PTUImp,'none')#</td>
            <td nowrap align="right">#LSCurrencyformat(rsReporte.AguiPag,'none')#</td>

         </tr>   
		</tr>
  
	</cfoutput>
</cfoutput>
<tr><td colspan="25" align="center"><strong><cf_translate key="LB_FinDelReporte"> --Fin Del Reporte-- </cf_translate></strong></td></tr>
</table>
