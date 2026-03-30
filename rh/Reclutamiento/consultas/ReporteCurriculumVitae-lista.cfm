
<cfset lvarReturn = "">

<cfset vJtreeJsonFormat = getListEmpresas() >

<cfif isDefined("form.esCorporativo") and len(trim(form.esCorporativo))>
	<cfset lvarCoorp = form.esCorporativo>
<cfelse>
	<cfset lvarCoorp = false>	
</cfif>

<cfif isDefined("form.tipoCmp") and len(trim(form.tipoCmp))>
	<cfset lvarTipoCmp = form.tipoCmp>
<cfelse>
	<cfset lvarTipoCmp = 'C'>	
</cfif>

<!--- Devuelve la lista de Competencias(Habilidades/Conocimientos) relacionadas a una o mas empresas si es corporativo --->
<cfif isdefined('form.GetListCmp')>
	<!--- Obtiene las competencias(Conocimientos/Habilidades) de una o mas empresas relacionadas --->
	<cf_translatedata tabla="RHConocimientos" col="rhc.RHCdescripcion" name="get" returnvariable="LvarRHCdescripcion"/>
	<cf_translatedata tabla="RHHabilidades" col="rhh.RHHdescripcion" name="get" returnvariable="LvarRHHdescripcion"/>
	<cfquery name="rsListCmp" datasource="#session.DSN#">
		select distinct 
		<cfif compare(lvarTipoCmp, 'C') eq 0 > 
			rhc.RHCcodigo as codigo, #LvarRHCdescripcion# as descripcion 
		<cfelse>  
			rhh.RHHcodigo as codigo, #LvarRHHdescripcion# as descripcion
		</cfif>
		from RHCompetenciasEmpleado rhce
		<cfif compare(lvarTipoCmp, 'C') eq 0 >
			inner join RHConocimientos rhc
		        on rhce.idcompetencia = rhc.RHCid
		        and rhce.Ecodigo = rhc.Ecodigo
		        and rhce.tipo = 'C' 
		<cfelse>  
			inner join RHHabilidades rhh
		        on rhce.idcompetencia = rhh.RHHid
		        and rhce.Ecodigo = rhh.Ecodigo
		        and rhce.tipo = 'H'
		</cfif>
		where rhce.Ecodigo in(<cfif not lvarCoorp>
	                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	                        <cfelse>    
	                            <cfif vJtreeJsonFormat neq 0>
	                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#vJtreeJsonFormat#" list="true">
	                            <cfelse>
	                                select Ecodigo from Empresas where
	                                cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	                            </cfif>
	                        </cfif>
						)
		order by <cfif compare(lvarTipoCmp, 'C') eq 0 > #LvarRHCdescripcion# <cfelse> #LvarRHHdescripcion# </cfif>
	</cfquery>

	<cfset lvarReturn = serializeJSON(rsListCmp)>
</cfif>

<!--- Devuelve la lista de Niveles relacionados a una o mas empresas si es corporativo --->
<cfif isdefined('form.GetListNiv')>
	<cf_translatedata tabla="RHNiveles" col="RHNdescripcion" name="get" returnvariable="LvarRHNdescripcion"/>
	<cfquery name="rsListNiv" datasource="#session.DSN#">
		select distinct RHNcodigo as codigo, #LvarRHNdescripcion# as descripcion
		from RHNiveles
		where Ecodigo in(<cfif not lvarCoorp>
	                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	                        <cfelse>    
	                            <cfif vJtreeJsonFormat neq 0>
	                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#vJtreeJsonFormat#" list="true">
	                            <cfelse>
	                                select Ecodigo from Empresas where
	                                cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	                            </cfif>
	                        </cfif>
						)
		and RHNhabcono = <cfqueryparam cfsqltype="cf_sql_char" value="#lvarTipoCmp#">
	</cfquery>
		
	<cfset lvarReturn = serializeJSON(rsListNiv)>	
</cfif>	

<!--- Devuelve la lista de Empresas relacionadas al activar la opcion corporativo --->
<cfif isdefined('form.GetListEmp')>
	<cfif isDefined("form.esCorporativo") and vJtreeJsonFormat neq 0 >
		<cfset vListaEmp = vJtreeJsonFormat >	
	<cfelse>
		<cfset vListaEmp = session.Ecodigo >	
	</cfif>

	<cfset vCount = 1 >
	<cfloop array="#Session.Conlises.Conlis#" index="i">
	    <cfset vFilterClis = i.filtro >
	    <cfset vExist = Find('Ecodigo in', vFilterClis) >

	    <cfif vExist neq 0>
	    	<cfif vExist gt 1>
		    	<cfset vExist = vExist - 1> 
		    </cfif>

	    	<cfif compare(Mid(vFilterClis, vExist, 1),'C') neq 0>
	    		<cfset vListLen = ListLen(vFilterClis, '(' ) >

			    <cfif vListLen gt 1 >
			        <cfset vFirst = listGetAt(vFilterClis, 1, '(') >
			        <cfset vTemp = listGetAt(vFilterClis, 2, '(') >

			        <cfset vListLen2 = ListLen(vTemp, ')' ) >
			        <cfif vListLen2 gt 1 >
			        	<cfset vSecond = listGetAt(vTemp, 2, ')') >
			        <cfelse>
			        	<cfset vSecond = ''>	
			        </cfif>	

			        <cfif vListLen eq 3>
			        	<cfset vThird = listGetAt(vFilterClis, 3, '(') > 
			        	<cfset vNewFilterClis = vFirst & '(#vListaEmp#)' & vSecond & '(' & vThird>
			        <cfelse>
			        	<cfset vNewFilterClis = vFirst & '(#vListaEmp#)' & vSecond >	
			        </cfif>
			        
			        <cfset Session.Conlises.Conlis[vCount].filtro = vNewFilterClis >
			    </cfif>
	    	</cfif>	
	    </cfif>

	    <cfset vCount += 1 >
	</cfloop>

	<cfset lvarReturn = vListaEmp >
</cfif>		

<!--- Funcion que obtiene la lista de empresas seleccionada mediante la opcion de corporativo --->
<cffunction name="getListEmpresas" returntype="String">
	<cfset empresas = "0">
	<cfif IsJSON(form.jtreeJsonFormat) and form.jtreejsonformat neq 0 >
	    <cfset arrayCorporativo = DeserializeJSON(form.jtreeJsonFormat)>
	    <cfif isArray(arrayCorporativo) and arrayLen(arrayCorporativo)> 
	        <cfset arrayCorporativo = arrayCorporativo[1]['values']>
	        <cfloop array="#arrayCorporativo#" index="i">
	            <cfset empresas = listAppend(empresas,i.key)>   
	        </cfloop>
	     </cfif>
	     <cfset form.jtreeJsonFormat = empresas>  
	</cfif>
	<cfif not len(trim(form.jtreeJsonFormat))>
	    <cfset form.jtreeJsonFormat = 0 >
	</cfif>

	<cfreturn form.jtreeJsonFormat>
</cffunction>

<cfoutput>#lvarReturn#</cfoutput>