<cfif isdefined('rsDetLT') and rsDetLT.RecordCount GT 0 and #vTLinea# EQ 'N' >
	<cfloop query="rsDetLT">
		<cfset DLTid 		= rsDetLT.LTid>
        
		<cfset unidades 	= rsDetLT.DLTunidades>
        <cfset montobase 	= rsDetLT.DLTmonto>
        <cfset monto 		= rsDetLT.DLTmonto>
        <!--- Averiguar si el salario de la plaza es negociado --->
        <cfquery name="rsNegociado" datasource="#Session.DSN#">
            select a.RHMPnegociado
            from RHLineaTiempoPlaza a
            where a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetLT.RHPid#">
            and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsDetLT.LTdesde)#"> between a.RHLTPfdesde and a.RHLTPfhasta
        </cfquery>
        <cfset LvarNegociado = (rsNegociado.RHMPnegociado EQ 'N')>
       
		<cfset metodo = 'M'>
		<cfif usaEstructuraSal EQ 1 >
			<cfset Lvar_RHTTid 	= 0>
			<cfset Lvar_RHMPPid = 0>
			<cfset Lvar_RHCid 	= 0>

			<cfif isdefined('Arguments.RHTTid3') and Len(Trim(Arguments.RHTTid3)) and Arguments.RHTTid3 GT 0>
				<cfset Lvar_RHTTid 	= Arguments.RHTTid3>
				<cfset Lvar_RHMPPid = Arguments.RHMPPid3>
				<cfset Lvar_RHCid 	= Arguments.RHCid3>
			</cfif>
            
        
          
            <!--- VERIFICAR SI TIENE UN PUESTO ALTERNO QUE CAMBIA LA CATEGORIA --->
             <cfset Lvar_CatAlt = rsDetLT.RHCPlinea>
            <cfif rsDetLT.RecordCount GT 0 and rsDetLT.RHPcodigoAlt GT 0>
                <cfquery name="rsCatPuestoAlt" datasource="#session.DSN#">
                    select RHCPlinea
                    from RHPuestos a
                    inner join RHMaestroPuestoP b
                        on b.RHMPPid = a.RHMPPid
                        and b.Ecodigo = a.Ecodigo
                    inner join RHCategoriasPuesto c
                        on c.RHMPPid = b.RHMPPid
                        and c.Ecodigo = b.Ecodigo
                    where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDetLT.RHPcodigoAlt#">
                      and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                </cfquery>
                <cfif isdefined('rsCatPuestoAlt') and rsCatPuestoAlt.RecordCount>
                    <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
                    <cfset Lvar_RHTTid = 0>
                    <cfset Lvar_RHMPPid = 0>
                    <cfset Lvar_RHCid = 0>
                </cfif>
            </cfif>

<!---            <cfif len(ltrim(rtrim(Lvar_CatAlt))) eq 0>
            	<cfdump var="#rsDetLT.LTid#">
             	<cf_dump var="#rsCatPuestoAlt#">
            </cfif>
--->            
            
            <cfquery name="rsCategoria" datasource="#session.DSN#">
                select e.RHCcodigo
                from RHCategoriasPuesto c
                        inner join RHCategoria e
                        on e.RHCid=c.RHCid
                where  c.RHCPlinea = <cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_CatAlt#">
            </cfquery>
            

            
            <cfset lvarVariables = StructNew()>
        	<cfset StructInsert(lvarVariables,"categoriaEmp",rsCategoria.RHCcodigo)>
            
			<cfinvoke component="rh.Componentes.RH_EstructuraSalarial" method="calculaComponente" returnvariable="calculaComponenteRet">
				<cfinvokeargument name="CSid" 				value="#rsDetLT.CSid#"/>
				<cfinvokeargument name="fecha" 				value="#rsDetLT.LTdesde#"/>
				<cfinvokeargument name="fechah" 			value="#rsDetLT.LThasta#"/>
				<cfinvokeargument name="DEid" 				value="#rsDetLT.DEid#"/>
				<cfinvokeargument name="RHCPlinea" 			value="#Lvar_CatAlt#"/>
				<cfinvokeargument name="BaseMontoCalculo" 	value="0.00"/>
				<cfinvokeargument name="negociado" 			value="#LvarNegociado#"/>
				<cfinvokeargument name="Unidades" 			value="#rsDetLT.DLTunidades#"/>
				<cfinvokeargument name="MontoBase" 			value="#rsDetLT.LTsalario#"/>
				<cfinvokeargument name="Monto" 				value="#rsDetLT.DLTmonto#"/>
				<cfinvokeargument name="Metodo" 			value="#rsDetLT.DLTmetodoC#"/>
				<cfinvokeargument name="TablaComponentes" 	value="DLineaTiempo"/>
				<cfinvokeargument name="CampoLlaveTC" 		value="LTid"/>
				<cfinvokeargument name="ValorLlaveTC" 		value="#rsDetLT.LTid#"/>
				<cfinvokeargument name="CampoMontoTC" 		value="DLTmonto"/>
                
				<cfinvokeargument name="RHTTid" 			value="#Lvar_RHTTid#">
				<cfinvokeargument name="RHCid" 				value="#Lvar_RHMPPid#">
				<cfinvokeargument name="RHMPPid" 			value="#Lvar_RHCid#">
                
				<cfinvokeargument name="PorcSalario" 		value="#rsDetLT.LTporcsal#"/>
				<cfinvokeargument name="RHCPlineaP" 		value="#rsDetLT.RHCPlineaP#"/>
                <cfinvokeargument name="FijarVariable" 		value="#lvarVariables#"/>
			</cfinvoke>

			<cfset unidades 	= calculaComponenteRet.Unidades>
			<cfset montobase 	= calculaComponenteRet.MontoBase>
			<cfset monto 		= calculaComponenteRet.Monto>
			<cfset metodo 		= calculaComponenteRet.Metodo>
			
			
			
			
            
		<cfelse> <!---No usa Estructura salarial--->
								
			<cfset Lvar_CatAlt = 0>
			
            <cfinvoke component="rh.Componentes.RH_SinEstructuraSalarial" method="calculaComponente" returnvariable="calculaComponenteRet">
				<cfinvokeargument name="CSid" 				value="#rsDetLT.CSid#"/>
				<cfinvokeargument name="fecha" 				value="#rsDetLT.LTdesde#"/>
				<cfinvokeargument name="fechah" 			value="#rsDetLT.LThasta#"/>
				<cfinvokeargument name="DEid" 				value="#rsDetLT.DEid#"/>
				<cfinvokeargument name="RHCPlinea" 			value="#Lvar_CatAlt#"/>
				<cfinvokeargument name="BaseMontoCalculo" 	value="0.00"/>
				<cfinvokeargument name="negociado" 			value="#LvarNegociado#"/>
				<cfinvokeargument name="Unidades" 			value="#rsDetLT.DLTunidades#"/>
				<cfinvokeargument name="MontoBase" 			value="#rsDetLT.LTsalario#"/>
				<cfinvokeargument name="Monto" 				value="#rsDetLT.DLTmonto#"/>
				<cfinvokeargument name="Metodo" 			value="#rsDetLT.DLTmetodoC#"/>
				<cfinvokeargument name="TablaComponentes" 	value="DLineaTiempo"/>
				<cfinvokeargument name="CampoLlaveTC" 		value="LTid"/>
				<cfinvokeargument name="ValorLlaveTC" 		value="#rsDetLT.LTid#"/>
				<cfinvokeargument name="CampoMontoTC" 		value="DLTmonto"/>
				<cfinvokeargument name="PorcSalario" 		value="#rsDetLT.LTporcsal#"/>
				<cfinvokeargument name="RHCPlineaP" 		value="#rsDetLT.RHCPlineaP#"/>
			</cfinvoke>
		
			<cfset unidades 	= calculaComponenteRet.unidades>
			<cfset montobase 	= calculaComponenteRet.monto>
			<cfset monto 		= calculaComponenteRet.monto>
			<cfset metodo 		= 'M'>
			
		</cfif>
		<cfif Len(Trim(unidades)) EQ 0 or Len(Trim(montobase)) EQ 0 or Len(Trim(monto)) EQ 0>
			<cf_throw message="#MSG_NoPuedeAplicarAccion#">
		</cfif>

		<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
			update DLineaTiempo
				set DLTunidades = <cfqueryparam cfsqltype="cf_sql_float" value="#unidades#">,
				DLTmonto 		= <cfqueryparam cfsqltype="cf_sql_money" value="#replace(monto, ',','','all')#">,
				DLTmetodoC 		= <cfqueryparam cfsqltype="cf_sql_char" value="#metodo#">,
				BMUsucodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			 where LTid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetLT.LTid#">
           		 and CSid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetLT.CSid#">
		</cfquery>
        <cfquery name="ABC_RHAcciones" datasource="#Session.DSN#"> <!---SML Inicio. Modificacion para que actualice el salario del empleado en LineaTiempo--->
			update LineaTiempo 
            set LTSalario = (select coalesce(SUM(DLTMonto),0) from DLineaTiempo 
							 where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetLT.LTid#">)
			 where LTid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetLT.LTid#">
		</cfquery> <!---SML Final. Modificacion para que actualice el salario del empleado en LineaTiempo--->
	</cfloop> 
<cfelseif isdefined('rsDetLTR') and rsDetLTR.RecordCount GT 0 and #vTLinea# EQ 'R' >
	<cfloop query="rsDetLTR">
		<cfset DLTid 		= rsDetLTR.LTRid>
        
		<cfset unidades 	= rsDetLTR.DLTunidades>
        <cfset montobase 	= rsDetLTR.DLTmonto>
        <cfset monto 		= rsDetLTR.DLTmonto>
        <!--- Averiguar si el salario de la plaza es negociado --->
        <cfquery name="rsNegociado" datasource="#Session.DSN#">
            select a.RHMPnegociado
            from RHLineaTiempoPlaza a
            where a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetLTR.RHPid#">
            and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsDetLTR.LTdesde)#"> between a.RHLTPfdesde and a.RHLTPfhasta
        </cfquery>
        <cfset LvarNegociado = (rsNegociado.RHMPnegociado EQ 'N')>
       
		<cfset metodo = 'M'>
		<cfif usaEstructuraSal EQ 1 >
			<cfset Lvar_RHTTid 	= 0>
			<cfset Lvar_RHMPPid = 0>
			<cfset Lvar_RHCid 	= 0>

			<cfif isdefined('Arguments.RHTTid3') and Len(Trim(Arguments.RHTTid3)) and Arguments.RHTTid3 GT 0>
				<cfset Lvar_RHTTid 	= Arguments.RHTTid3>
				<cfset Lvar_RHMPPid = Arguments.RHMPPid3>
				<cfset Lvar_RHCid 	= Arguments.RHCid3>
			</cfif>
            
              <!--- VERIFICAR SI TIENE UN PUESTO ALTERNO QUE CAMBIA LA CATEGORIA --->
            <cfset Lvar_CatAlt = rsDetLTR.RHCPlinea>
             
            <cfif rsDetLTR.RecordCount GT 0 and rsDetLTR.RHPcodigoAlt GT 0>
                <cfquery name="rsCatPuestoAlt" datasource="#session.DSN#">
                    select RHCPlinea
                    from RHPuestos a
                    inner join RHMaestroPuestoP b
                        on b.RHMPPid = a.RHMPPid
                        and b.Ecodigo = a.Ecodigo
                    inner join RHCategoriasPuesto c
                        on c.RHMPPid = b.RHMPPid
                        and c.Ecodigo = b.Ecodigo
                    where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDetLTR.RHPcodigoAlt#">
                      and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                </cfquery>
                <cfif isdefined('rsCatPuestoAlt') and rsCatPuestoAlt.RecordCount>
                    <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
                    <cfset Lvar_RHTTid = 0>
                    <cfset Lvar_RHMPPid = 0>
                    <cfset Lvar_RHCid = 0>
                </cfif>
            </cfif>
            
            <cfquery name="rsCategoria" datasource="#session.DSN#">
                select e.RHCcodigo
                from RHCategoriasPuesto c
                        inner join RHCategoria e
                        on e.RHCid=c.RHCid
                where  c.RHCPlinea = <cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_CatAlt#">
            </cfquery>
            
			<cfset lvarVariables = StructNew()>
        	<cfset StructInsert(lvarVariables,"categoriaEmp",rsCategoria.RHCcodigo)>
		
			<cfinvoke component="rh.Componentes.RH_EstructuraSalarial" method="calculaComponente" returnvariable="calculaComponenteRet">
				<cfinvokeargument name="CSid" 				value="#rsDetLTR.CSid#"/>
				<cfinvokeargument name="fecha" 				value="#rsDetLTR.LTdesde#"/>
				<cfinvokeargument name="fechah" 			value="#rsDetLTR.LThasta#"/>
				<cfinvokeargument name="DEid" 				value="#rsDetLTR.DEid#"/>
				<cfinvokeargument name="RHCPlinea" 			value="#Lvar_CatAlt#"/>
				<cfinvokeargument name="BaseMontoCalculo" 	value="0.00"/>
				<cfinvokeargument name="negociado" 			value="#LvarNegociado#"/>
				<cfinvokeargument name="Unidades" 			value="#rsDetLTR.DLTunidades#"/>
				<cfinvokeargument name="MontoBase" 			value="#rsDetLTR.LTsalario#"/>
				<cfinvokeargument name="Monto" 				value="#rsDetLTR.DLTmonto#"/>
				<cfinvokeargument name="Metodo" 			value="#rsDetLTR.DLTmetodoC#"/>
				<cfinvokeargument name="TablaComponentes" 	value="DLineaTiempoR"/>
				<cfinvokeargument name="CampoLlaveTC" 		value="LTRid"/>
				<cfinvokeargument name="ValorLlaveTC" 		value="#rsDetLTR.LTRid#"/>
				<cfinvokeargument name="CampoMontoTC" 		value="DLTmonto"/>
                
				<cfinvokeargument name="RHTTid" 			value="#Lvar_RHTTid#">
				<cfinvokeargument name="RHCid" 				value="#Lvar_RHMPPid#">
				<cfinvokeargument name="RHMPPid" 			value="#Lvar_RHCid#">
                
				<cfinvokeargument name="PorcSalario" 		value="#rsDetLTR.LTporcsal#"/>
				<cfinvokeargument name="RHCPlineaP" 		value="#rsDetLTR.RHCPlineaP#"/>
                <cfinvokeargument name="FijarVariable" 		value="#lvarVariables#"/>
			</cfinvoke>

			<cfset unidades 	= calculaComponenteRet.Unidades>
			<cfset montobase 	= calculaComponenteRet.MontoBase>
			<cfset monto 		= calculaComponenteRet.Monto>
			<cfset metodo 		= calculaComponenteRet.Metodo>
            
		<cfelse> <!---No usa Estructura salarial--->

            <cfinvoke component="rh.Componentes.RH_SinEstructuraSalarial" method="calculaComponente" returnvariable="calculaComponenteRet">
				<cfinvokeargument name="CSid" 				value="#rsDetLTR.CSid#"/>
				<cfinvokeargument name="fecha" 				value="#rsDetLTR.LTdesde#"/>
				<cfinvokeargument name="fechah" 			value="#rsDetLTR.LThasta#"/>
				<cfinvokeargument name="DEid" 				value="#rsDetLTR.DEid#"/>
				<cfinvokeargument name="RHCPlinea" 			value="#rsDetLTR.RHCPlinea#"/>
				<cfinvokeargument name="BaseMontoCalculo" 	value="0.00"/>
				<cfinvokeargument name="negociado" 			value="#LvarNegociado#"/>
				<cfinvokeargument name="Unidades" 			value="#rsDetLTR.DLTunidades#"/>
				<cfinvokeargument name="MontoBase" 			value="#rsDetLTR.LTsalario#"/>
				<cfinvokeargument name="Monto" 				value="#rsDetLTR.DLTmonto#"/>
				<cfinvokeargument name="Metodo" 			value="#rsDetLTR.DLTmetodoC#"/>
				<cfinvokeargument name="TablaComponentes" 	value="DLineaTiempoR"/>
				<cfinvokeargument name="CampoLlaveTC" 		value="LTRid"/>
				<cfinvokeargument name="ValorLlaveTC" 		value="#rsDetLTR.LTRid#"/>
				<cfinvokeargument name="CampoMontoTC" 		value="DLTmonto"/>
				<cfinvokeargument name="PorcSalario" 		value="#rsDetLTR.LTporcsal#"/>
				<cfinvokeargument name="RHCPlineaP" 		value="#rsDetLTR.RHCPlineaP#"/>
			</cfinvoke>
		
			<cfset unidades 	= calculaComponenteRet.unidades>
			<cfset montobase 	= calculaComponenteRet.monto>
			<cfset monto 		= calculaComponenteRet.monto>
			<cfset metodo 		= 'M'>
			
		</cfif>
		<cfif Len(Trim(unidades)) EQ 0 or Len(Trim(montobase)) EQ 0 or Len(Trim(monto)) EQ 0>
			<cf_throw message="#MSG_NoPuedeAplicarAccion#">
		</cfif>

		<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
			update DLineaTiempoR
				set DLTunidades = <cfqueryparam cfsqltype="cf_sql_float" value="#unidades#">,
				DLTmonto 		= <cfqueryparam cfsqltype="cf_sql_money" value="#replace(monto, ',','','all')#">,
				DLTmetodoC 		= <cfqueryparam cfsqltype="cf_sql_char" value="#metodo#">,
				BMUsucodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			 where LTRid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetLTR.LTRid#">
           		 and CSid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetLTR.CSid#">
		</cfquery>
	</cfloop> 
</cfif>	