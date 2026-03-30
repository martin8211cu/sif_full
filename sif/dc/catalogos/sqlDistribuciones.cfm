<cfif isdefined("botonSel") and botonSel eq "Nuevo" and form.tab eq 1>
	
	<cfset pagina = "Distribuciones.cfm?IDgd=#form.IDgd#">
	<cfset tab = 1>

<cfelseif isdefined("form.Alta") and isdefined("form.tab") and form.tab eq 1>

	<!--- Verifica si ya existe esa distribucion creada
	<cfquery datasource="#session.DSN#" name="sqlVerificarDist">
	Select count(1) as existe
	from DCDistribucion
	where IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboIDgd#">
	  and Tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboTipo#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

	<cfset total = sqlVerificarDist.existe>
	
	<cfif total eq 0> --->
		<cfset marcado = "N">
		<cfif isdefined("form.chkdesc")>
			<cfset marcado = "S">	
		</cfif>


		<cftransaction>	
		<cfquery datasource="#session.DSN#" name="sqlInsDistribucion">
		INSERT into DCDistribucion(Ecodigo,	IDgd,	Tipo, Descripcion, EliNeg)
		Values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboIDgd#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboTipo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtdesc#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#marcado#">)
		
				<cf_dbidentity1 datasource="#Session.DSN#">
		 </cfquery>
		 <cf_dbidentity2 datasource="#Session.DSN#" name="sqlInsDistribucion">	
		 </cftransaction>
		 
		<cfset VIDdistribucion = sqlInsDistribucion.identity>
		<cfset VIDgd = form.cboIDgd>
		<cfset pagina = "Distribuciones.cfm?IDdistribucion=#VIDdistribucion#&IDgd=#VIDgd#">
		<cfset tab = 1>
		<!---
	<cfelse>
		<cf_errorCode	code = "50350" msg = "Ya existe una distirbucion para ese grupo y tipo">
	</cfif>--->

<cfelseif isdefined("form.Cambio") and isdefined("form.tab") and form.tab eq 1>

	<!--- Verifica si ya existe una distribucion creada con ese origen y tipo
	<cfquery datasource="#session.DSN#" name="sqlVerificarDist">
	Select count(1) as existe
	from DCDistribucion
	where IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboIDgd#">
	  and Tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboTipo#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	
	<cfset total = sqlVerificarDist.existe>
	
	<cfif total eq 0>--->	

		<cfset marcado = "N">
		<cfif isdefined("form.chkdesc")>
			<cfset marcado = "S">	
		</cfif>

		<cftransaction>	
	
			<cfquery datasource="#session.DSN#" name="sqlInsDistribucion">
			Update DCDistribucion
			set IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboIDgd#">,	
			    Tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboTipo#">,
			    Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.txtdesc#">,
			    EliNeg = <cfqueryparam cfsqltype="cf_sql_char" value="#marcado#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">
			</cfquery>
	
		</cftransaction>

		<cfset VIDdistribucion = form.IDdistribucion>
		<cfset VIDgd = form.IDgd>
		<cfset pagina = "Distribuciones.cfm?IDdistribucion=#VIDdistribucion#&IDgd=#VIDgd#">
		<cfset tab = 1>	
<!---
	<cfelse>
		<cf_errorCode	code = "50351" msg = "Ya existe una distirbucion para ese grupo, de este tipo">
	</cfif>		--->

<cfelseif isdefined("form.Baja") and isdefined("form.tab") and form.tab eq 1>

	<cfset Msgerror="">
	<!--- Se verifica que no existan cuentas destino asociadas --->
	<cfquery datasource="#session.DSN#" name="sqlVerCuentasDestino">
	Select count(1) as cantidad
	from DCCtasDestino
	where IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">
	</cfquery>
	
	<cfif sqlVerCuentasDestino.cantidad gt 0>
		<cfset Msgerror="ERROR: No es posible eliminar la distribución. Existen cuentas destino asociadas.">
	</cfif>
	
	<!--- Se verifica que no existan cuentas origen asociadas --->
	<cfquery datasource="#session.DSN#" name="sqlVerCuentasOrigen">
	Select count(1) as cantidad
	from DCCtasOrigen
	where IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">	
	</cfquery>
	
	<cfif sqlVerCuentasOrigen.cantidad gt 0>
		<cfset Msgerror="ERROR: No es posible eliminar la distribución. Existen cuentas origen asociadas.">
	</cfif>
	
	<cfif Msgerror neq "">
		<cfthrow message="#Msgerror#">	
	<cfelse>
	
		<cfquery datasource="#session.DSN#" name="sqlEliminar">
		Delete from DCDistribucion 
		where IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">
		</cfquery>	
		
		<cfset VIDdistribucion = form.IDdistribucion>
		<cfset VIDgd = form.IDgd>
		<cfset pagina = "lstDistribuciones.cfm?IDdistribucion=#VIDdistribucion#&IDgd=#VIDgd#">
		<cfset tab = 1>
	
	</cfif>

<!--- CUENTA DESTINO --->	
<cfelseif isdefined("form.Alta") and isdefined("form.tab") and form.tab eq 3>
	
	<cfif form.CtaFinalcmpdest eq "">

		<!--- Si no viene un complemento, se hace la inserción --->

		<!--- Verifica si esta excluida --->
		<cfif isdefined("form.chkCDexcluir")>
			<cfset chkexcluir = 1>
		<cfelse>
			<cfset chkexcluir = 0>
		</cfif>

		<cfquery datasource="#session.DSN#">
		INSERT into DCCtasDestino (IDdistribucion,	Ecodigo, Ocodigo, CDformato, CDcomplemento, CDporcentaje, CDexcluir)
		VALUES (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.txtOcodigoDestino#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DCtaFinal#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CtaFinalcmpdest#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#form.txtCDporcentaje#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#chkexcluir#">)
		</cfquery>

		<cfset VIDdistribucion = form.IDdistribucion>
		<cfset VIDgd = form.IDgd>
		<cfset pagina = "Distribuciones.cfm?IDdistribucion=#VIDdistribucion#&IDgd=#VIDgd#">
		<cfset tab = 3>	


	<cfelse>

		<!--- Si el complemento viene, se valida que las cuentas de mayor sean iguales --->

		<!--- SE VERIFICA QUE EL COMPLEMENTO Y LA CUENTA MAYOR DEL FORMATO SEAN IGUALES --->	
		<cfset Mayor = #mid(form.DCtaFinal,1,4)#>
		<cfset MayorCmp = #mid(form.CtaFinalcmpdest,1,4)#>


		<cfif Mayor eq MayorCmp>


			<!--- Verifica si esta excluida --->
			<cfif isdefined("form.chkCDexcluir")>
				<cfset chkexcluir = 1>
			<cfelse>
				<cfset chkexcluir = 0>
			</cfif>
	
			<cfquery datasource="#session.DSN#">
			INSERT into DCCtasDestino (IDdistribucion,	Ecodigo, Ocodigo, CDformato, CDcomplemento, CDporcentaje, CDexcluir)
			VALUES (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.txtOcodigoDestino#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DCtaFinal#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CtaFinalcmpdest#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#form.txtCDporcentaje#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#chkexcluir#">)
			</cfquery>

			<cfset VIDdistribucion = form.IDdistribucion>
			<cfset VIDgd = form.IDgd>
			<cfset pagina = "Distribuciones.cfm?IDdistribucion=#VIDdistribucion#&IDgd=#VIDgd#">
			<cfset tab = 3>	
	
		<cfelse>
			<cf_errorCode	code = "50352" msg = "No es posible incluir la cuenta destino, porque la cuenta mayor del complemento es diferente a la cuenta mayor del formato de la cuenta">
		</cfif>

	</cfif>

<cfelseif isdefined("form.Cambio") and isdefined("form.tab") and form.tab eq 3>


	<cfif form.CtaFinalcmpdest eq "">

		<!--- Verifica si esta excluida --->
		<cfif isdefined("form.chkCDexcluir")>
			<cfset chkexcluir = 1>
		<cfelse>
			<cfset chkexcluir = 0>
		</cfif>


		<cfquery datasource="#session.DSN#">
		UPDATE DCCtasDestino 
		set Ocodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.txtOcodigoDestino#">,
		    CDformato     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DCtaFinal#">,
		    CDcomplemento = null,
			CDporcentaje  = <cfqueryparam cfsqltype="cf_sql_float" value="#form.txtCDporcentaje#">,
		    CDexcluir     = <cfqueryparam cfsqltype="cf_sql_bit" value="#chkexcluir#">
		where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Id#">
		  and IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
		</cfquery>

		<cfset VIDdistribucion = form.IDdistribucion>
		<cfset VIDgd = form.IDgd>
		<cfset pagina = "Distribuciones.cfm?IDdistribucion=#VIDdistribucion#&Id=#form.Id#&IDgd=#VIDgd#">
		<cfset tab = 3>	

	<cfelse>	

		<!--- SE VERIFICA QUE EL COMPLEMENTO Y LA CUENTA MAYOR DEL FORMATO SEAN IGUALES --->	
		<cfset Mayor = #mid(form.DCtaFinal,1,4)#>
		<cfset MayorCmp = #mid(form.CtaFinalcmpdest,1,4)#>
	
		<cfif Mayor eq MayorCmp>


			<!--- Verifica si esta excluida --->
			<cfif isdefined("form.chkCDexcluir")>
				<cfset chkexcluir = 1>
			<cfelse>
				<cfset chkexcluir = 0>
			</cfif>


			<cfquery datasource="#session.DSN#">
			UPDATE DCCtasDestino 
			set Ocodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.txtOcodigoDestino#">,
			    CDformato     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DCtaFinal#">,
			    CDcomplemento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CtaFinalcmpdest#">,
			    CDporcentaje  = <cfqueryparam cfsqltype="cf_sql_float" value="#form.txtCDporcentaje#">,
			    CDexcluir     = <cfqueryparam cfsqltype="cf_sql_bit" value="#chkexcluir#">
			where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Id#">
			  and IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
			</cfquery>

			<cfset VIDdistribucion = form.IDdistribucion>
			<cfset VIDgd = form.IDgd>
			<cfset pagina = "Distribuciones.cfm?IDdistribucion=#VIDdistribucion#&Id=#form.Id#&IDgd=#VIDgd#">
			<cfset tab = 3>	

		<cfelse>
			<cf_errorCode	code = "50353"
							msg  = "No es posible modificar la cuenta destino, porque la cuenta mayor del complemento es diferente a la cuenta mayor del formato de la cuenta @errorDat_1@ - @errorDat_2@"
							errorDat_1="#Mayor#"
							errorDat_2="#MayorCmp#"
			>
		</cfif>

	</cfif>

<cfelseif isdefined("botonSel") and botonSel eq "Nuevo" and form.tab eq 3>

	<cfset VIDdistribucion = form.IDdistribucion>
	<cfset VIDgd = form.IDgd>
	<cfset pagina = "Distribuciones.cfm?IDdistribucion=#VIDdistribucion#&IDgd=#VIDgd#">
	<cfset tab = 3>

<cfelseif isdefined("form.Baja") and isdefined("form.tab") and form.tab eq 3>

	<cfquery datasource="#session.DSN#">
	DELETE from DCCtasDestino 
	where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Id#">
	  and IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
	</cfquery>

	<cfset VIDdistribucion = form.IDdistribucion>
	<cfset VIDgd = form.IDgd>
	<cfset pagina = "Distribuciones.cfm?IDdistribucion=#VIDdistribucion#&IDgd=#VIDgd#">
	<cfset tab = 3>	

<!--- CUENTA ORIGEN --->
<cfelseif isdefined("form.Alta") and isdefined("form.tab") and form.tab eq 2>

	<cfif not isdefined("form.txtCDporcentajeorg")>
		<cfset form.txtCDporcentajeorg = 0>
	</cfif>

	<cfif form.CtaFinalcmp eq "">

		<cfif isdefined("form.usaConductor") and form.usaConductor gt 0>
			<!--- 
			En el caso de haber un conductor es necesario evaluar la cuenta mayor del complemento de debito
			--->

			<cfset Mayor = #mid(form.CtaFinal,1,4)#>

			<cfset MayorCmpD = #mid(form.CtaFinalcmpD,1,4)#>				
			<cfif MayorCmpD neq "" and MayorCmpD neq Mayor>
				<cf_errorCode	code = "50354" msg = "No es posible incluir la cuenta origen, porque la cuenta mayor de los complementos enc caso de incluirlos, debe ser igual a la cuenta mayor de la cuenta origen.">
			</cfif>
		</cfif>	

			<cfquery datasource="#session.DSN#">
			INSERT into DCCtasOrigen (	IDdistribucion,	
							Ecodigo, 
							Ocodigo, 
							CDformato, 
							CDcomplemento, 							
							CDporcentaje
							<cfif isdefined("form.usaConductor") and form.usaConductor gt 0>
								,CGCid
								,CDcomplementoOrg
							</cfif>
										)
			VALUES (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.txtOcodigoOrigen#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CtaFinal#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CtaFinalcmp#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#form.txtCDporcentajeorg#">
				
				<cfif isdefined("form.usaConductor") and form.usaConductor gt 0>
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboConductor#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CtaFinalcmpD#">
				</cfif>
				
				)				
			</cfquery>
	
			<cfset VIDdistribucion = form.IDdistribucion>
			<cfset VIDgd = form.IDgd>
			<cfset pagina = "Distribuciones.cfm?IDdistribucion=#VIDdistribucion#&IDgd=#VIDgd#">
			<cfset tab = 2>	

	<cfelse>

		<!--- SE VERIFICA QUE EL COMPLEMENTO Y LA CUENTA MAYOR DEL FORMATO SEAN IGUALES --->	
		<cfset Mayor = #mid(form.CtaFinal,1,4)#>
		<cfset MayorCmp = #mid(form.CtaFinalcmp,1,4)#>
		<cfset Lvarinsertar=1>

		<cfif isdefined("form.usaConductor") and form.usaConductor gt 0>
			<cfset MayorCmpD = #mid(form.CtaFinalcmpD,1,4)#>	
			<cfset Lvarinsertar=0>
			<cfif MayorCmpD neq "" and MayorCmpD eq Mayor>
				<cfset Lvarinsertar=1>
			<cfelseif MayorCmpD eq "">
				<cfset Lvarinsertar=1>
			</cfif>
		</cfif>	
	
		<cfif (Mayor eq MayorCmp) and Lvarinsertar eq 1>
	
			<cfquery datasource="#session.DSN#">
			INSERT into DCCtasOrigen (	IDdistribucion,	
							Ecodigo, 
							Ocodigo, 
							CDformato, 
							CDcomplemento, 
							CDporcentaje
							<cfif isdefined("form.usaConductor") and form.usaConductor gt 0>
								,CGCid
								,CDcomplementoOrg
							</cfif>										
						)
			VALUES (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.txtOcodigoOrigen#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CtaFinal#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CtaFinalcmp#">,			
				<cfqueryparam cfsqltype="cf_sql_float" value="#form.txtCDporcentajeorg#">
				<cfif isdefined("form.usaConductor") and form.usaConductor gt 0>
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboConductor#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CtaFinalcmpD#">
				</cfif>				
				)
			</cfquery>
	
			<cfset VIDdistribucion = form.IDdistribucion>
			<cfset VIDgd = form.IDgd>
			<cfset pagina = "Distribuciones.cfm?IDdistribucion=#VIDdistribucion#&IDgd=#VIDgd#">
			<cfset tab = 2>	
	
		<cfelse>
			<cf_errorCode	code = "50355" msg = "No es posible incluir la cuenta origen, porque la cuenta mayor del complemento es diferente a la cuenta mayor del formato de la cuenta">
		</cfif>

	</cfif>

<cfelseif isdefined("form.Cambio") and isdefined("form.tab") and form.tab eq 2>

	<cfif not isdefined("form.txtCDporcentajeorg")>
		<cfset form.txtCDporcentajeorg = 0>
	</cfif>	
	
	<cfif form.CtaFinalcmp eq "">


		<cfif isdefined("form.usaConductor") and form.usaConductor gt 0>
			<!--- 
			En el caso de haber un conductor es necesario evaluar la cuenta mayor del complemento de debito
			--->

			<cfset Mayor = #mid(form.CtaFinal,1,4)#>

			<cfset MayorCmpD = #mid(form.CtaFinalcmpD,1,4)#>				
			<cfif MayorCmpD neq "" and MayorCmpD neq Mayor>
				<cf_errorCode	code = "50356" msg = "No es posible actualizar la cuenta origen, porque la cuenta mayor de los complementos en caso de incluirlos, debe ser igual a la cuenta mayor de la cuenta origen.">
			</cfif>
		</cfif>	


		<cfquery datasource="#session.DSN#">
		UPDATE DCCtasOrigen
		set Ocodigo 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.txtOcodigoOrigen#">,
			CDformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CtaFinal#">,			
			CDcomplemento= null,
			CDporcentaje = <cfqueryparam cfsqltype="cf_sql_float" value="#form.txtCDporcentajeorg#">
			
			<cfif isdefined("form.usaConductor") and form.usaConductor gt 0>
				,CGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboConductor#">
				,CDcomplementoOrg = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CtaFinalcmpD#">
			</cfif>	
					
		where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Id#">
		  and IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
		</cfquery>

		<cfset VIDdistribucion = form.IDdistribucion>
		<cfset VIDgd = form.IDgd>
		<cfset pagina = "Distribuciones.cfm?IDdistribucion=#VIDdistribucion#&Id=#form.Id#&IDgd=#VIDgd#">
		<cfset tab = 2>	

	<cfelse>

		<!--- SE VERIFICA QUE EL COMPLEMENTO Y LA CUENTA MAYOR DEL FORMATO SEAN IGUALES --->	
		<cfset Mayor = #mid(form.CtaFinal,1,4)#>
		<cfset MayorCmp = #mid(form.CtaFinalcmp,1,4)#>
		<cfset LvarUpdte=1>

		<cfif isdefined("form.usaConductor") and form.usaConductor gt 0>
			<cfset MayorCmpD = #mid(form.CtaFinalcmpD,1,4)#>
			<cfset Lvarinsertar=0>
			<cfif MayorCmpD neq "" and MayorCmpD eq Mayor>
				<cfset LvarUpdte=1>
			<cfelseif MayorCmpD eq "">
				<cfset LvarUpdte=1>
			</cfif>
		</cfif>	
	
		<cfif Mayor eq MayorCmp and LvarUpdte eq 1>

			<cfquery datasource="#session.DSN#">
			UPDATE DCCtasOrigen
			set Ocodigo 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.txtOcodigoOrigen#">,
				CDformato 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CtaFinal#">,
				CDcomplemento= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CtaFinalcmp#">,
				CDporcentaje = <cfqueryparam cfsqltype="cf_sql_float" value="#form.txtCDporcentajeorg#">
			
				<cfif isdefined("form.usaConductor") and form.usaConductor gt 0>
					,CGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboConductor#">
					,CDcomplementoOrg = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CtaFinalcmpD#">
				</cfif>
			
			where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Id#">
			  and IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
			</cfquery>

			<cfset VIDdistribucion = form.IDdistribucion>
			<cfset VIDgd = form.IDgd>
			<cfset pagina = "Distribuciones.cfm?IDdistribucion=#VIDdistribucion#&Id=#form.Id#&IDgd=#VIDgd#">
			<cfset tab = 2>	

		<cfelse>
			<cf_errorCode	code = "50357" msg = "No es posible modificar la cuenta origen, porque la cuenta mayor del complemento es diferente a la cuenta mayor del formato de la cuenta">
		</cfif>
	</cfif>

<cfelseif isdefined("botonSel") and botonSel eq "Nuevo" and form.tab eq 2>

	<cfset VIDdistribucion = form.IDdistribucion>
	<cfset VIDgd = form.IDgd>
	<cfset pagina = "Distribuciones.cfm?IDdistribucion=#VIDdistribucion#&IDgd=#VIDgd#">
	<cfset tab = 2>

<cfelseif isdefined("form.Baja") and isdefined("form.tab") and form.tab eq 2>

	<cfquery datasource="#session.DSN#">
	DELETE from DCCtasOrigen 
	where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Id#">
	  and IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
	</cfquery>

	<cfset VIDdistribucion = form.IDdistribucion>
	<cfset VIDgd = form.IDgd>
	<cfset pagina = "Distribuciones.cfm?IDdistribucion=#VIDdistribucion#&IDgd=#VIDgd#">
	<cfset tab = 2>	

</cfif>

<cfoutput>
<form method="post" name="frm_back" action="#pagina#">
	<input type="hidden" name="tab" value="#tab#">
	<cfif tab eq 1>
		<input type="hidden" name="modo" value="<cfif isdefined("form.Alta")>Cambio</cfif>">	
	</cfif>
</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>


