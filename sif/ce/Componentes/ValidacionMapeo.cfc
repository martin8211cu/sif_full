<cfcomponent>
	<cffunction name="ValMapeoCtasContables">
    	<cfargument name="idAgrupador" type="string">
        <cfargument name="Nivel"       type="numeric"   default="-1">
        <cfargument name="Periodo"     type="numeric">
        <cfargument name="Mes" 		   type="numeric">
		<cfargument name="GEid" 	   type="string" 	default="-1">
		<cfargument name="idBalComp" 	type="numeric" 	default="-1">

		<cfinclude template="../../Utiles/sifConcat.cfm">

			<cfquery name="rsIncluyeCuentasOrden" datasource="#session.DSN#">
				select isnull(Pvalor,'N') Pvalor
                from Parametros
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    and Pcodigo = 200081
			</cfquery>

			<cfinvoke component="sif.Componentes.ErrorProceso" method="delErrors">
                	<cfinvokeargument name="Spcodigo"   	value="#session.menues.SPcodigo#">
                    <cfinvokeargument name="Ecodigo"   		value="#session.Ecodigo#">
            </cfinvoke>


			<cfquery name="insError" datasource="#session.dsn#">
					INSERT INTO ErrorProceso
				    (
				    		[Ecodigo]
				           ,[Spcodigo]
				           ,[Usucodigo]
				           ,[Descripcion]
				    )
				    select
				    	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				    	<cfqueryparam cfsqltype="cf_sql_varchar"   	value="#session.menues.SPcodigo#">,
				    	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				    	'La cuenta ' #_Cat# rtrim(ltrim(Cformato))  #_Cat# ', ' #_Cat# rtrim(ltrim(Cdescripcion))  #_Cat# ' no se encuentra mapeada'
	                from (
	                select * from (
						 select
							Cformato,Cdescripcion,Ccuenta,
						       case Ctipo
								when 'A' then 'Activo'
								when 'P' then 'Pasivo'
								when 'C' then 'Capital'
								when 'I' then 'Ingreso'
								when 'G' then 'Gasto'
								when 'O' then 'Orden'
								else 'N/A'
							end as DescripcionTipo
					     from (	select Cformato,Cdescripcion,Ctipo,ctasSaldos.Ccuenta
					       from (
					            SELECT	distinct ctas.Ccuenta, ctas.Cformato, ctas.Cdescripcion, ctas.Ecodigo,ctas.Cmayor, ctas.PCDCniv,ctas.Ctipo
					            from (
					            			select distinct a.Ccuenta, a.Cformato, a.Cdescripcion, a.Ecodigo,a.Cmayor, b.PCDCniv, cm.Ctipo
					                    	from CContables a
											inner join CtasMayor cm
												on a.Cmayor = cm.Cmayor and a.Ecodigo = cm.Ecodigo
					                    	INNER JOIN PCDCatalogoCuenta b
					                     		on a.Ccuenta = b.Ccuentaniv
					                    	<cfif isdefined('nivel.Pvalor') and #nivel.Pvalor# EQ -1>
												and a.Cmovimiento = 'S'
											<cfelse>
					                        	and b.PCDCniv <= (
					                        						select isnull(Pvalor,2) Pvalor
					                                            	from Parametros
					                                            	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					                                                	and Pcodigo = 200080) -1
					                    	</cfif>
											where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											and not exists (
															select 1
															from CEInactivas e
															where a.Ccuenta = e.Ccuenta
																and a.Ecodigo = e.Ecodigo
																<cfif Arguments.GEid NEQ -1>
																and GEid = #Arguments.GEid#
																</cfif>
															)
								) ctas
								INNER JOIN (
					            			select Ccuenta, Ecodigo from SaldosContables
											where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											<cfif isdefined("form.periodo") and form.periodo neq "-1" and isdefined("form.mes") and form.mes neq "-1">
								            	and Speriodo*100+Smes <= #form.periodo*100+form.mes#
											</cfif>
								) c
					               	on ctas.Ccuenta = c.Ccuenta
									and ctas.Ecodigo = c.Ecodigo
							<cfif Arguments.idBalComp NEQ -1>
								INNER JOIN (
					            			select formato from DCGRBalanceComprobacion
					            			where CGRBCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalComp#">
								) c2
					               	on ctas.Cformato = c2.formato
							</cfif>
								where ctas.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							 ) ctasSaldos
					         left join CEMapeoSAT cSAT
					             on ctasSaldos.Ccuenta = cSAT.Ccuenta
					             and cSAT.CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idAgrupador#">
					             <cfif Arguments.GEid NEQ -1>
					             and cSAT.GEid = #Arguments.GEid#
					             </cfif>
					         where cSAT.Ccuenta is null
							 <cfif rsIncluyeCuentasOrden.Pvalor EQ 'N'>
								and ctasSaldos.Ctipo <> 'O'
							 </cfif>
						) ctaNomap
						UNION ALL
						select
							Cformato,Cdescripcion,Ccuenta,
						       case Ctipo
								when 'A' then 'Activo'
								when 'P' then 'Pasivo'
								when 'C' then 'Capital'
								when 'I' then 'Ingreso'
								when 'G' then 'Gasto'
								when 'O' then 'Orden'
								else 'N/A'
							end as DescripcionTipo
						FROM (
							select distinct a.Ccuenta, a.Cformato, a.Cdescripcion, a.Ecodigo,a.Cmayor, b.PCDCniv, cm.Ctipo
					        from CContables a
							inner join CtasMayor cm
								on a.Cmayor = cm.Cmayor
								and a.Ecodigo = cm.Ecodigo
					        INNER JOIN PCDCatalogoCuenta b
					            on a.Ccuenta = b.Ccuentaniv
					        <cfif isdefined('Arguments.Nivel') and #Arguments.Nivel# EQ -1>
								and a.Cmovimiento = 'S'
							<cfelse>
					            and b.PCDCniv <= (
					                select isnull(Pvalor,2) Pvalor
					                from Parametros
					                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					                	and Pcodigo = 200080) -1
					        </cfif>
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							and not exists (select 1 from CEInactivas e where a.Ccuenta = e.Ccuenta and a.Ecodigo = e.Ecodigo
												<cfif Arguments.GEid NEQ -1>
													and GEid = #Arguments.GEid#
												</cfif>)
							and not exists (select 1 from CEMapeoSAT cst where a.Ccuenta = cst.Ccuenta and a.Ecodigo = cst.Ecodigo
												<cfif Arguments.GEid NEQ -1>
												and GEid = #Arguments.GEid#
												</cfif>
												and cst.CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.idAgrupador#">)
							<cfif rsIncluyeCuentasOrden.Pvalor EQ 'N'>
								and cm.Ctipo <> 'O'
							</cfif>
						) a
						where not exists (
								select 1 from SaldosContables b where a.Ecodigo = b.Ecodigo and a.Ccuenta = b.Ccuenta
							)
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					) result
					where not exists (
						select 1 from  (
							select distinct a.Ccuenta, a.Cformato, a.Cdescripcion, a.Ecodigo,a.Cmayor, b.PCDCniv, cm.Ctipo
							from CContables a
							inner join CtasMayor cm on a.Cmayor = cm.Cmayor and a.Ecodigo = cm.Ecodigo
							INNER JOIN PCDCatalogoCuenta b on a.Ccuenta = b.Ccuentaniv
							where b.PCDCniv = 0 and not exists (select 1 from CContables cc where a.Ccuenta = cc.Cpadre and a.Ecodigo = cc.Ecodigo)
						) cmns where result.Ccuenta = cmns.Ccuenta)
				) rsE
			</cfquery>

    		<cfquery name="rsMapeoSaldosCont" datasource="#session.DSN#">
            	select top 1 * from ErrorProceso
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and Spcodigo = <cfqueryparam cfsqltype="cf_sql_varchar"   	value="#session.menues.SPcodigo#">
				    and Usucodigo = <cfqueryparam cfsqltype="cf_sql_varchar"   	value="#session.Usucodigo#">
        	</cfquery>

            <cfset resError = true>

            <cfif isdefined('rsMapeoSaldosCont') and rsMapeoSaldosCont.RecordCount GT 0>
            	<cfset resError = false>
            </cfif>

            <cfreturn resError>
    </cffunction>

	<cffunction name="CleanHighAscii" access="public" returntype="string" output="false">
	    <!--- Define arguments. --->
	    <cfargument name="Text" type="string" required="true" />

	    <!--- Set up local scope. --->
	    <cfset var LOCAL = {} />

	    <!---
	        When cleaning the string, there are going to be ascii
	        values that we want to target, but there are also going
	        to be high ascii values that we don't expect. Therefore,
	        we have to create a pattern that simply matches all non
	        low-ASCII characters. This will find all characters that
	        are NOT in the first 127 ascii values. To do this, we
	        are using the 2-digit hex encoding of values.
	    --->
	    <cfset LOCAL.Pattern = CreateObject( "java", "java.util.regex.Pattern" ).Compile(JavaCast( "string", "[^\x00-\x7F]" ))/>

	    <!---
	        Create the pattern matcher for our target text. The
	        matcher will be able to loop through all the high
	        ascii values found in the target string.
	    --->
	    <cfset LOCAL.Matcher = LOCAL.Pattern.Matcher(JavaCast( "string", ARGUMENTS.Text )) />

	    <!---
	        As we clean the string, we are going to need to build
	        a results string buffer into which the Matcher will
	        be able to store the clean values.
	    --->
	    <cfset LOCAL.Buffer = CreateObject("java", "java.lang.StringBuffer").Init() />

	    <!--- Keep looping over high ascii values. --->
	    <cfloop condition="LOCAL.Matcher.Find()">

	        <!--- Get the matched high ascii value. --->
	        <cfset LOCAL.Value = LOCAL.Matcher.Group() />

	        <!--- Get the ascii value of our character. --->
	        <cfset LOCAL.AsciiValue = Asc( LOCAL.Value ) />

	        <!---
	            Now that we have the high ascii value, we need to
	            figure out what to do with it. There are explicit
	            tests we can perform for our replacements. However,
	            if we don't have a match, we need a default
	            strategy and that will be to just store it as an
	            escaped value.
	        --->

	        <!--- Check for Microsoft double smart quotes. --->
	        <cfif ((LOCAL.AsciiValue EQ 8220) OR (LOCAL.AsciiValue EQ 8221))>

	            <!--- Use standard quote. --->
	            <cfset LOCAL.Value = """" />

	        <!--- Check for Microsoft single smart quotes. --->
	        <cfelseif ((LOCAL.AsciiValue EQ 8216) OR (LOCAL.AsciiValue EQ 8217))>

	            <!--- Use standard quote. --->
	            <cfset LOCAL.Value = "'" />

	        <!--- Check for Microsoft elipse. --->
	        <cfelseif (LOCAL.AsciiValue EQ 8230)>

	            <!--- Use several periods. --->
	            <cfset LOCAL.Value = "..." />

	        <cfelse>

	            <!---
	                We didn't get any explicit matches on our
	                character, so just store the escaped value.
	            --->
	            <cfset LOCAL.Value = "" />

	        </cfif>


	        <!---
	            Add the cleaned high ascii character into the
	            results buffer. Since we know we will only be
	            working with extended values, we know that we don't
	            have to worry about escaping any special characters
	            in our target string.
	        --->
	        <cfset LOCAL.Matcher.AppendReplacement(LOCAL.Buffer, JavaCast( "string", LOCAL.Value )) />

	    </cfloop>

	    <!---
	        At this point there are no further high ascii values
	        in the string. Add the rest of the target text to the
	        results buffer.
	    --->
	    <cfset LOCAL.Matcher.AppendTail(LOCAL.Buffer) />

	    <!--- Return the resultant string. --->
	    <cfreturn LOCAL.Buffer.ToString() />
	</cffunction>
	
</cfcomponent>