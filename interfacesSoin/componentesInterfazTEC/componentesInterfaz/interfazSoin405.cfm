<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- <cfif listLen(GvarXML_IE) neq 9>
	<cfthrow message="#GvarXML_IE#">
</cfif> --->


<cfset XMLD = xmlParse(GvarXML_IE) />
<cfset Datos = xmlSearch(XMLD,'/resultset/row')>
<cfset datosXML = xmlparse(Datos[1]) />

<cfset LvarEcodigo			= #datosXML.row.Ecodigo.xmltext#>
<cfset LvarOficodigo		= #datosXML.row.Oficodigo.xmltext#>
<cfset LvarCFcodigo			= #datosXML.row.CFcodigo.xmltext#>
<cfset LvarDEidentificacion	= #datosXML.row.DEidentificacion.xmltext#>
<cfset LvarTipoCuenta		= #datosXML.row.TipoCuenta.xmltext#>
<cfset LvarCmayor			= #datosXML.row.Cmayor.xmltext#>
<cfset LvarListaPCDvalor	= #datosXML.row.ListaPCDvalor.xmltext#>
<cfset LvarListaPosiciones	= #datosXML.row.ListaPosiciones.xmltext#>
<cfset LvarOrdenado     	= #datosXML.row.Orderby.xmltext#>


<!--- Tipo de Cuenta
	GA-Cuenta de Gasto
	IT-Cuenta de Inventario
	IS-Cuenta de Inversión
	AC-Cuenta de Activos
	IN-Cuenta de Ingreso
	OI-Cuenta de Otros Ingresos
	OG-Cuenta de Otros Gastos
	OB-Cuenta de Obras
	PA-Cuenta de Ingreso por Patrimonio
--->

	
<!--------        Ecodigo      ------------->
<!---Si no pasan el Ecodigo se toma el
 de la session                          ---->
	<cfif len(trim(LvarEcodigo)) eq 0 or LvarEcodigo eq -1>
	  <cfset LvarEcodigo = #session.Ecodigo#>
	 <cfelse>
	  	<cfquery name="rsEmpresa" datasource="#session.dsn#">
		 Select count(1) as cantidadE  from Empresa 
		 where Ecodigo = #LvarEcodigo#
		</cfquery>	
		<cfif rsEmpresa.cantidadE eq 0>
		   <cfthrow message="El código de la empresa no coincide con ninguna empresa. Proceso Cancelado!!">
		</cfif>
	</cfif>
<!----                                  ---->		

<!--------    Tipo de Cuenta   ------------>
<cfif not listfind('GA,IT,IS,AC,IN,OI,OG,OB,PA,-1',trim(LvarTipoCuenta))>
	<cfthrow message="Tipo de cuenta indefinido, valores permetido son: GA:Cuenta de Gasto, IT:Cuenta de Inventario, IS:Cuenta de Inversión, AC:Cuenta de Activos, IN:Cuenta de Ingreso, OI:Cuenta de Otros Ingresos, OG:Cuenta de Otros Gastos, OB:Cuenta de Obras, PA:Cuenta de Ingreso por Patrimonio, -1: NO FILTRAR">
</cfif>
<cfswitch expression="#LvarTipoCuenta#">
	<cfcase value="GA">
		<cfset lvarCuentas = "CFcuentac">
	</cfcase>
	<cfcase value="IT">
		<cfset lvarCuentas = "CFcuentainventario">
	</cfcase>
	<cfcase value="IS">
		<cfset lvarCuentas = "CFcuentainversion">
	</cfcase>
	<cfcase value="AC">
		<cfset lvarCuentas = "CFcuentaaf">
	</cfcase>
	<cfcase value="IN">
		<cfset lvarCuentas = "CFcuentaingreso">
	</cfcase>
	<cfcase value="OI">
		<cfset lvarCuentas = "CFcuentaingresoretaf">
	</cfcase>
	<cfcase value="OG">
		<cfset lvarCuentas = "CFcuentagastoretaf">
	</cfcase>
	<cfcase value="OB">
		<cfset lvarCuentas = "CFcuentaobras">
	</cfcase>
	<cfcase value="PA">
		<cfset lvarCuentas = "CFcuentaPatri">
	</cfcase>
	<cfcase value="-1">
		<cfset lvarCuentas = "CFcuentac, CFcuentainventario, CFcuentainversion, CFcuentaaf, CFcuentaingreso, CFcuentaingresoretaf, CFcuentagastoretaf, CFcuentaobras, CFcuentaPatri">
	</cfcase>
</cfswitch>
<cfset lvarCuentasQuery = "">

	
<!--------------- Cuenta Mayor   ------------------->
<!------------  Si me pasan la cuenta mayor  ------->
<cfif len(trim(LvarCmayor)) neq 0 and LvarCmayor neq -1 >

	<cfset hoy = DatePart("yyyy", now()) * 100 + DatePart("m", now()) >
	<cfquery name="rsCMayor" datasource="#session.dsn#">
		select c.Ecodigo, c.Cmayor, c.CEcodigo, c.PCEMid, m.PCEMformato, v.CPVformatoF
		from CtasMayor c
			left outer join PCEMascaras m
				on m.PCEMid = c.PCEMid
			left outer join CPVigencia v
				on v.Ecodigo= c.Ecodigo and v.Cmayor = c.Cmayor 
				  and  #hoy# >= CPVdesdeAnoMes and #hoy# <= CPVhastaAnoMes
		where c.Ecodigo = #LvarEcodigo#
		  and c.Cmayor = '#LvarCmayor#'
	</cfquery>
	<cfif rsCMayor.recordcount eq 0>
		<cfthrow message="La cuenta mayor no existe, el proceso no puede continuar. Proceso Cancelado!!!">
	</cfif>
	
	<cfif len(trim(rsCMayor.PCEMformato)) eq 0 and len(trim(rsCMayor.CPVformatoF)) eq 0>
		<cfthrow message="La cuenta no posee un formato definido. Proceso Cancelado!!!">
	</cfif>
</cfif>
<!-------------------------------------------------->
			
			   
 <cfset validar = false>  
<cfif (len(trim(LvarListaPosiciones)) and LvarListaPosiciones neq -1  or len(trim(LvarListaPCDvalor))) and LvarListaPCDvalor neq -1 >
	<cfset validar = true>
</cfif>		
		
<cfif validar> 
		
		         <cfif len(trim(LvarCmayor)) eq 0 or LvarCmayor eq -1 >
				     <cfthrow message="Se ha definido fuentes de financiamiento, pero no se ha indicado una cuenta Mayor. Proceso Cancelado!!!">
				 </cfif>	

 		         <cfif len(trim(LvarTipoCuenta)) eq 0 or LvarTipoCuenta eq -1 >
				     <cfthrow message="Se ha definido fuentes de financiamiento, pero no se ha indicado un tipo de cuenta. Proceso Cancelado!!!">
				 </cfif>				 				
		
				 <!----  Si pasan posiciones y valores ----->
				 <cfif len(trim(LvarListaPosiciones)) neq 0 and len(trim(LvarListaPCDvalor)) neq 0>   
					<cfif not (listlen(LvarListaPosiciones,'|') eq listlen(LvarListaPCDvalor,'|'))>
						<cfthrow message="La cantidad de valores al catálogo al plan de compras es diferente al las posiciones . Cantidad de valores: #listlen(LvarListaPCDvalor,'|')# - Cantidad de posiciones: #listlen(LvarListaPosiciones,'|')#">
					</cfif>
				 </cfif>	
				 
				<cfset lvarLenPos = listlen(LvarListaPosiciones,'|')>
				<cfset lvarLenVal = listlen(LvarListaPCDvalor,'|')>
			
				<!-----Busca si en los arreglos viene un -1 ------->
				<cfloop from="1" to="#lvarLenPos#" index="indice">
						<cfset VarPos = listgetat(LvarListaPosiciones,indice,'|')>
						<cfif rtrim(VarPos) eq -1>
						   <cfthrow message="Las posiciones no pueden llevar un -1">
						</cfif>												
				</cfloop>					
				<cfloop from="1" to="#lvarLenVal#" index="indice">
						<cfset VarVal = listgetat(LvarListaPCDvalor,indice,'|')>
						<cfif rtrim(VarVal) eq -1>
						   <cfthrow message="Los valores no pueden llevar un -1">
						</cfif>												
				</cfloop>					
							
				<cfset struct = StructNew()>
				<cfif len(trim(rsCMayor.PCEMid))>
					<cfloop from="1" to="#lvarLenPos#" index="indice">
						<cfset pos = listgetat(LvarListaPosiciones,indice,'|')>
						<cfquery name="rsNiveles" datasource="#session.dsn#">
							select (select sum(PCNlongitud) 
									from PCNivelMascara 
									where PCEMid = #rsCMayor.PCEMid# and PCNid < #pos#) + #pos+5# as PosIni
								,PCNlongitud 
							from PCNivelMascara
							where PCEMid = #rsCMayor.PCEMid# and PCNid = #pos#
						</cfquery>
						<cfset StructInsert(struct, indice, '#rsNiveles.PosIni#|#rsNiveles.PCNlongitud#|#listgetat(LvarListaPCDvalor,indice,'|')#')>
					</cfloop>
				<cfelseif len(trim(rsCMayor.CPVformatoF))>
					<cfset posIni = 0>
					<cfset lvarLenFormato = listlen(rsCMayor.CPVformatoF,'-')>
					<cfset structPosFormato = StructNew()>
					<cfloop from="2" to="#lvarLenFormato#" index="indice">
						<cfset posIni = posIni + len(listgetat(rsCMayor.CPVformatoF,indice - 1,'-'))>
						<cfset StructInsert(structPosFormato, indice - 1, "#posIni + indice#|#len(listgetat(rsCMayor.CPVformatoF,indice,'-'))#")>
					</cfloop>
					<cfloop from="1" to="#lvarLenPos#" index="indice">
						<cfset pos = listgetat(LvarListaPosiciones,indice,'|')>
						<cfif not StructKeyExists(structPosFormato, '#pos#')>
							<cfthrow message="La posición #pos# no existe la cuenta #LvarCmayor#. Proceso Cancelado!!!">
						</cfif>
						<cfset listFormato = StructFind(structPosFormato,'#pos#')>
						<cfset StructInsert(struct, indice, "#listgetat(listFormato,1,'|')#|#listgetat(listFormato,2,'|')#|#listgetat(LvarListaPCDvalor,indice,'|')#")>
					</cfloop>
				</cfif>
				<cfloop list="#lvarCuentas#" index="cta">
					<cfloop from="1" to="#lvarLenPos#" index="indice">
						<cfset structVal = StructFind(struct,'#indice#')>
						<cf_dbfunction name="sPart" args="#cta#,#listgetat(structVal,1,'|')#,#listgetat(structVal,2,'|')#" returnvariable="lvarSPcuenta">
						<cf_dbfunction name="sPart" args="#cta#,1,4" returnvariable="lvarCtaM">
						<cfset lvarCuentasQuery = lvarCuentasQuery & " and #lvarCtaM# = '#LvarCmayor#' and #lvarSPcuenta# = '#listgetat(structVal,3,'|')#'">
					</cfloop>
				</cfloop>
			</cfif>


        <!--------   DEIdentificacion ------------->
	<cfif len(trim(LvarDEidentificacion)) neq 0 and LvarDEidentificacion neq -1>	   
		<cfquery name="rsEmpleado" datasource="#session.dsn#">
		  Select 
		    DEid
		   from  DatosEmpleado 
		    where 
			DEidentificacion = '#LvarDEidentificacion#'
		</cfquery>
		<cfif rsEmpleado.recordcount eq 0>
				<cfthrow message="La identificación enviada no esta asociada a ningun empleado. Proceso Cancelado!!">
		<cfelse>
				 <cfquery name="rsReferencia" datasource="#session.dsn#">
				  select Usucodigo from UsuarioReferencia where llave ='#rsEmpleado.DEid#'
				 </cfquery>
				 
				 <cfif rsReferencia.recordcount eq 0>
					<cfthrow message="El usuario no ha sido referenciado. Proceso Cancelado!!">
				 <cfelse>
				 
				 	 <!---------- Centro funcional Con responsable definido------------>
				   	 <cfquery name="rsCFuncional" datasource="#session.dsn#">					  
                        	select CFid, CFcodigo, CFdescripcion, CFidresp, CFuresponsable, o.Oficodigo, cf.Ocodigo, o.Odescripcion,#preservesinglequotes(lvarCuentas)#
							from CFuncional cf
								inner join Oficinas o
									on o.Ocodigo = cf.Ocodigo and o.Ecodigo = cf.Ecodigo
							where cf.Ecodigo = #LvarEcodigo#	
							and CFuresponsable =#rsReferencia.Usucodigo# 							
							<cfif len(trim(LvarCFcodigo)) and LvarCFcodigo neq -1>	
								and CFcodigo = '#LvarCFcodigo#'
							</cfif>							
							<cfif len(trim(LvarOficodigo)) and LvarOficodigo neq -1>	
								and o.Oficodigo = '#LvarOficodigo#'
							</cfif>	
							<cfif len(trim(lvarCuentasQuery))>	
								#preservesinglequotes(lvarCuentasQuery)#
							</cfif>	
							<cfif len(trim(LvarOrdenado)) and LvarOrdenado eq 1>	
								order by CFdescripcion asc	
							</cfif>					  
					 </cfquery>
					 <cfif rsCFuncional.recordcount eq 0>
					    <cfthrow message="El usuario no es responsable de ningun centro funcional. Proceso Cancelado!!">
					 </cfif>					 					 
	             </cfif> 	 
		</cfif>		
     <cfelse> 
	   	<!----- Centro funcional sin responsable definido ------->
		<cfquery name="rsCFuncional" datasource="#session.dsn#">
			select CFid, CFcodigo, CFdescripcion, CFidresp, CFuresponsable, o.Oficodigo, cf.Ocodigo, o.Odescripcion,#preservesinglequotes(lvarCuentas)#
			from CFuncional cf
				inner join Oficinas o
					on o.Ocodigo = cf.Ocodigo and o.Ecodigo = cf.Ecodigo
			where cf.Ecodigo = #LvarEcodigo#	
			
			<cfif len(trim(LvarCFcodigo)) and LvarCFcodigo neq -1>	
				and CFcodigo = '#LvarCFcodigo#'
			</cfif>
			
			<cfif len(trim(LvarOficodigo)) and LvarOficodigo neq -1>	
				and o.Oficodigo = '#LvarOficodigo#'
			</cfif>	
			<cfif len(trim(lvarCuentasQuery))>	
				#preservesinglequotes(lvarCuentasQuery)#
			</cfif>
			<cfif len(trim(LvarOrdenado)) and LvarOrdenado eq 1>	
				order by CFdescripcion asc	
			</cfif>	
	</cfquery>			

		
		<cfif rsCFuncional.recordcount EQ 0>
			<cfthrow message="Código del Centro Funcional o Código de la Oficina erroneo: CFcodigo = #LvarCFcodigo#, Oficodigo = #LvarOficodigo#">
		</cfif>
	
	</cfif>		
      <!---------------------------------------->
	
<cfset LvarIrresponsable = -1>
<cfset LvarTabla = "<resulset>">
	<cfloop query="rsCFuncional">		
		<cfif len(trim(LvarDEidentificacion)) eq 0 or LvarDEidentificacion eq -1>		
				<!---1.	Invocación para obtener el DEid, del responsable del Centro Funcional--->
				<cfinvoke component="rh.Componentes.RH_Funciones" 
					method="DeterminaDEidResponsableCF"
					cfid = "#rsCFuncional.CFid#"
					fecha = "#now()#"
					returnvariable="ResponsableCF"> 
				</cfinvoke>
				<cfif not len(trim(ResponsableCF))>
					<cfset ResponsableCF = -1>
				</cfif>				  	
		     <cfset VarEmpleado= #ResponsableCF#>
		<cfelse>
     		 <cfset VarEmpleado= #rsReferencia.Usucodigo#>
		</cfif>
		 
		<cfquery name="rsDatosEmpleado" datasource="#session.dsn#">
			select DEid, DEidentificacion, DEnombre as DEnombre, DEapellido1, DEapellido2 
			from DatosEmpleado
			where Ecodigo = #LvarEcodigo#
			<cfif len(trim(LvarDEidentificacion)) eq 0 or LvarDEidentificacion eq -1>	
				  and DEid = #VarEmpleado#
			<cfelseif len(trim(LvarDEidentificacion)) neq 0 and LvarDEidentificacion neq -1>
				  and DEidentificacion= '#LvarDEidentificacion#'
			</cfif>			  
		</cfquery>		

		<cfset lvarDEid = -1>

		<cfif len(trim(rsDatosEmpleado.DEid))>
			<cfset lvarDEid = rsDatosEmpleado.DEid>
		</cfif>		
		
		<cfquery name="rsLineaTiempo" datasource="#session.dsn#">
			select LTdesde, LThasta
			from LineaTiempo
			where Ecodigo= #LvarEcodigo#
			  and DEid = #lvarDEid#
			  and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">  between LTdesde and LThasta
		</cfquery>		
		<cfif len(trim(rsCFuncional.CFidresp)) gt 0> 
			<cfquery name="rsPadreRes" datasource="#session.dsn#">
				select coalesce(CFcodigo,'-1') as CFcodigo, coalesce(CFdescripcion,'-1') as CFdescripcion
				from CFuncional 
				 where CFid = #rsCFuncional.CFidresp#
			</cfquery>
			<cfif rsPadreRes.recordcount gt 0>
				<cfset LvarCFcodigoResp= rsPadreRes.CFcodigo>
				<cfset LvarCFdescrResp = rsPadreRes.CFdescripcion>
			</cfif>
		<cfelse>
		    <cfset LvarCFcodigoResp= '-1'>
			<cfset LvarCFdescrResp = '-1'>
		</cfif>	
		
		
		<cfset LvarTabla = LvarTabla & " 
		<row>
			<Empresa>#LvarEcodigo#</Empresa>
			<Oficodigo>#rsCFuncional.Oficodigo#</Oficodigo>
			<Odescripcion>#rsCFuncional.Odescripcion#</Odescripcion>
			<CFcodigo>#rsCFuncional.CFcodigo#</CFcodigo>
			<CFdescripcion>#rsCFuncional.CFdescripcion#</CFdescripcion>">
			
		<cfif rsDatosEmpleado.recordcount gt 0>	
			<cfset LvarTabla = LvarTabla & "	
                <LTdesde>#LsDateFormat(rsLineaTiempo.LTdesde,'dd-mm-YYYY')#</LTdesde>
                <LThasta>#LsDateFormat(rsLineaTiempo.LThasta,'dd-mm-YYYY')#</LThasta>
                <DEidentificacion>#rsDatosEmpleado.DEidentificacion#</DEidentificacion>
                <DEnombre>#rsDatosEmpleado.DEnombre#</DEnombre>
                <DEapellido1>#rsDatosEmpleado.DEapellido1#</DEapellido1>
                <DEapellido2>#rsDatosEmpleado.DEapellido2#</DEapellido2> 
                ">
		<cfelse>	
			<cfset LvarTabla = LvarTabla & "	
                <LTdesde>-1</LTdesde>
                <LThasta>-1</LThasta>
                <DEidentificacion>-1</DEidentificacion>
                <DEnombre>-1</DEnombre>
                <DEapellido1>-1</DEapellido1>
                <DEapellido2>-1</DEapellido2> 
                ">
        </cfif>
			
		<cfloop list="#lvarCuentas#" index="cta">
			<cfset LvarTabla = LvarTabla & "<#trim(cta)#>#evaluate('rsCFuncional.' & trim(cta))#</#trim(cta)#> "> 
		</cfloop>
    		<cfset LvarTabla = LvarTabla & "
			<CodigoPadre>#LvarCFcodigoResp#</CodigoPadre>
			<DescrPadre>#LvarCFdescrResp#</DescrPadre>">
		<cfset LvarTabla = LvarTabla & " </row>">
	</cfloop>
<cfset LvarTabla &= "</resulset>">
<cfset GvarXML_OE = LvarTabla>

