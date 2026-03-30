<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into CMTipoOrden(
			                        CMTOcodigo
						           ,Ecodigo
				                   ,CMTOdescripcion
					               ,Usucodigo
					               ,CMTOfalta
						           ,FMT01COD
			                       ,CMTgeneratracking
				                   ,CMTOimportacion
					               ,CMTOte
			                       ,CMTOtransportista
				                   ,CMTOtipotrans
					               ,CMTOincoterm
						           ,CMTOlugarent
								   <cfif isdefined('form.McodigoOri')     and Len(rtrim(form.McodigoOri)) GT 0>,Mcodigo</cfif>
                                   ,CMTOMontoMin
                                   ,CMTOMontoMax
                                   ,CMTOModFechaEntrega
                                   ,CMTOModDescripcion
                                   ,CMTOModFechaRequerida
                                   ,CMTOModImpuesto
								   ,CMTOModDescripcionE
								   ,CMTOModCodigoEnc
								   
				      )
				values (
				        <cfqueryparam value="#Form.CMTOcodigo#" cfsqltype="cf_sql_char">
						,<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						,<cfqueryparam value="#Form.CMTOdescripcion#" cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">
						,<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
						,<cfif isdefined("Form.FMT01COD")><cfqueryparam value="#Form.FMT01COD#" cfsqltype="cf_sql_char"><cfelse>null</cfif>
						,<cfif isdefined("form.CMTgeneratracking")>1<cfelse>0</cfif>
						,<cfif isdefined("form.CMTOimportacion")>1<cfelse>0</cfif>
						,<cfif isdefined("form.CMTOte")>1<cfelse>0</cfif>
						,<cfif isdefined("form.CMTOtransportista")>1<cfelse>0</cfif>
						,<cfif isdefined("form.CMTOtipotrans")>1<cfelse>0</cfif>
						,<cfif isdefined("form.CMTOincoterm")>1<cfelse>0</cfif>
						,<cfif isdefined("form.CMTOlugarent")>1<cfelse>0</cfif>
						
						 <cfif isdefined('form.McodigoOri') and Len(rtrim(form.McodigoOri)) GT 0>
						   , <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">
					     </cfif>
						 <cfif isdefined('form.CMTOMontoMin') and form.CMTOMontoMin GT 0.00>
					        ,<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.CMTOMontoMin,',','','ALL')#">
						 <cfelse>
						  ,<cfqueryparam cfsqltype="cf_sql_money" value="0.00">
						 </cfif>
						 <cfif isdefined('form.CMTOMontoMax') and form.CMTOMontoMax GT 0.00>
							,<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.CMTOMontoMax,',','','ALL')#">
						 <cfelse>
						 ,<cfqueryparam cfsqltype="cf_sql_money" value="0.00">
						 </cfif>
                         ,<cfif isdefined("form.CMTOModFechaEntrega")>1<cfelse>0</cfif>
                         ,<cfif isdefined("form.CMTOModDescripcion")>1<cfelse>0</cfif>
                         ,<cfif isdefined("form.CMTOModFechaRequerida")>1<cfelse>0</cfif>
                         ,<cfif isdefined("form.CMTOModImpuesto")>1<cfelse>0</cfif>
						 ,<cfif isdefined("form.CMTOModDescripcionEnc")>1<cfelse>0</cfif>
						 ,<cfif isdefined("form.CMTOcodigoEnc")>1<cfelse>0</cfif>
				)
		</cfquery>		   
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from CMTipoOrden
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and CMTOcodigo = <cfqueryparam value="#Form.xCMTOcodigo#"   cfsqltype="cf_sql_char">
		</cfquery>  
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="CMTipoOrden"
			 			redirect="TiposOrdenCompra.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="CMTOcodigo" 
						type2="char" 
						value2="#form.xCMTOcodigo#"	>

		<cfquery name="update" datasource="#Session.DSN#">
			update CMTipoOrden set
				<cfif trim(Form.xCMTOcodigo) NEQ trim(Form.CMTOcodigo)>CMTOcodigo = <cfqueryparam value="#Form.CMTOcodigo#" cfsqltype="cf_sql_char">,</cfif>
				CMTOdescripcion = <cfqueryparam value="#Form.CMTOdescripcion#" cfsqltype="cf_sql_varchar">,
				FMT01COD = <cfif isdefined("Form.FMT01COD")><cfqueryparam value="#Form.FMT01COD#" cfsqltype="cf_sql_char"><cfelse>null</cfif>,
				CMTgeneratracking = <cfif isdefined("form.CMTgeneratracking")>1<cfelse>0</cfif>,
				CMTOimportacion = <cfif isdefined("form.CMTOimportacion")>1<cfelse>0</cfif>,
				CMTOte = <cfif isdefined("form.CMTOte")>1<cfelse>0</cfif>,
				CMTOtransportista = <cfif isdefined("form.CMTOtransportista")>1<cfelse>0</cfif>,
				CMTOtipotrans = <cfif isdefined("form.CMTOtipotrans")>1<cfelse>0</cfif>,
				CMTOincoterm = <cfif isdefined("form.CMTOincoterm")>1<cfelse>0</cfif>,
				CMTOlugarent = <cfif isdefined("form.CMTOlugarent")>1<cfelse>0</cfif>
                 
				 <cfif isdefined('form.McodigoOri') and Len(rtrim(form.McodigoOri)) GT 0>   
					,Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri#">
				</cfif>				 
				 <cfif isdefined('form.CMTOMontoMin')   and form.CMTOMontoMin GT 0.00>
				  	,CMTOMontoMin = <CF_jdbcquery_param cfsqltype="cf_sql_money" value="#replace(form.CMTOMontoMin,',','','ALL')#">					                
				</cfif>
				<cfif isdefined('form.CMTOMontoMax')   and form.CMTOMontoMax GT 0.00>
					,CMTOMontoMax =   <CF_jdbcquery_param cfsqltype="cf_sql_money" value="#replace(form.CMTOMontoMax,',','','ALL')#">
				</cfif>			
                ,CMTOModFechaEntrega   = <cfif isdefined("form.CMTOModFechaEntrega")>1<cfelse>0</cfif>
                ,CMTOModDescripcion    = <cfif isdefined("form.CMTOModDescripcion")>1<cfelse>0</cfif>	
                ,CMTOModFechaRequerida = <cfif isdefined("form.CMTOModFechaRequerida")>1<cfelse>0</cfif>
                ,CMTOModImpuesto	   = <cfif isdefined("form.CMTOModImpuesto")>1<cfelse>0</cfif>				
				,CMTOModDescripcionE	   = <cfif isdefined("form.CMTOModDescripcionEnc")>1<cfelse>0</cfif>
				,CMTOModCodigoEnc	   = <cfif isdefined("form.CMTOcodigoEnc")>1<cfelse>0</cfif>
			where Ecodigo    = <cfqueryparam value="#Session.Ecodigo#"  cfsqltype="cf_sql_integer">
			  and CMTOcodigo = <cfqueryparam value="#Form.xCMTOcodigo#" cfsqltype="cf_sql_char">
		</cfquery> 
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="TiposOrdenCompra.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="CMTOcodigo" type="hidden" value="<cfif isdefined("Form.CMTOcodigo") and modo neq 'ALTA'>#Form.CMTOcodigo#</cfif>">
</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

