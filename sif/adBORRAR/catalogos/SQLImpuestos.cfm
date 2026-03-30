<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into Impuestos( 	Ecodigo, Icodigo, Idescripcion, Iporcentaje, Ccuenta,CcuentaCxC,CcuentaCxCAcred,CcuentaCxPAcred, Icompuesto, Icreditofiscal, 
									InoRetencion, Usucodigo, Ifecha )
			values (<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">,
					<cfqueryparam value="#Form.Idescripcion#" cfsqltype="cf_sql_varchar">,
					 
					<cfif isdefined("Form.Icompuesto")>
						0.00,
						null,
						null,
						null,
						null,
					 	1,
						0,
					<cfelse>
						<cfqueryparam value="#Form.Iporcentaje#" cfsqltype="cf_sql_float">,
					 	<cfqueryparam value="#Form.Ccuenta#" cfsqltype="cf_sql_numeric">,
						<cfif isdefined("Form.CcuentaCxC") and len(trim(form.CcuentaCxC))>
							<cfqueryparam value="#Form.CcuentaCxC#" cfsqltype="cf_sql_numeric">,
						<cfelse>
							null,						
						</cfif>
						<cfif isdefined("Form.CcuentaCxCAcred") and len(trim(form.CcuentaCxCAcred))>
							<cfqueryparam value="#Form.CcuentaCxCAcred#" cfsqltype="cf_sql_numeric">,
						<cfelse>
							null,						
						</cfif>
						<cfif isdefined("Form.CcuentaCxPAcred") and len(trim(form.CcuentaCxPAcred))>
							<cfqueryparam value="#Form.CcuentaCxPAcred#" cfsqltype="cf_sql_numeric">,
						<cfelse>
							null,						
						</cfif>						
					 	0,
						<cfif isdefined("Form.Icreditofiscal")>	
							1, 
						<cfelse> 
							0, 
						</cfif>
					</cfif>
					 
					<cfparam name="form.InoRetencion" default="0">
					<cfqueryparam value="#form.InoRetencion#" cfsqltype="cf_sql_bit">,
					<cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
			       )
		</cfquery>		   
		<cfif isdefined("Form.Icompuesto")>
			<cfset action = "DetImpuestos.cfm">
			<cfset modo="CAMBIO">	
		<cfelse>
			<cfset modo="ALTA">	
		</cfif>
	
	<cfelseif isdefined("Form.Baja")>
		<cftransaction>
			<cfquery name="delete" datasource="#Session.DSN#">
				delete from DImpuestos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfquery name="delete" datasource="#Session.DSN#">
				delete from Impuestos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
			</cfquery>
		</cftransaction>
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="Impuestos"
			 			redirect="Impuestos.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="Icodigo" 
						type2="char" 
						value2="#form.Icodigo#"
						>
		<!--- 		
		<cfquery name="deleteDetalle" datasource="#Session.DSN#">
			delete from DImpuestos 
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
		</cfquery> 
		---> 
		
		<cfif not isdefined("Form.Icompuesto") and Form.IcompuestoX EQ 1 >
			<cfquery name="rsTieneRegistros" datasource="#Session.DSN#">
				select * from DImpuestos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
			</cfquery>
			
			<cfif rsTieneRegistros.recordCount GT 0>
				<cf_errorCode	code = "50025" msg = "El registro no puede ser modificado, debido a que tiene dependencias asociadas.">
			</cfif>
		</cfif>

		<cfquery name="update" datasource="#Session.DSN#">
			update Impuestos 
			set	Idescripcion = <cfqueryparam value="#Form.Idescripcion#" cfsqltype="cf_sql_varchar">,
				<cfparam name="form.InoRetencion" default="0">
				InoRetencion = <cfqueryparam value="#form.InoRetencion#" cfsqltype="cf_sql_bit">,

				<cfif isdefined("Form.Icompuesto")>
					Iporcentaje = (select coalesce(sum(DIporcentaje),0)
								from DImpuestos b
								where b.Icodigo = Impuestos.Icodigo
								and b.Ecodigo = Impuestos.Ecodigo),
					Ccuenta 		=  	null,
					CcuentaCxC 		=	null,
					CcuentaCxCAcred	=	null,
					CcuentaCxPAcred	=	null,
					Icompuesto = 1,
					Icreditofiscal = 0,
				<cfelse>
					Iporcentaje = <cfqueryparam value="#Form.Iporcentaje#" cfsqltype="cf_sql_float">,
					Ccuenta 		= <cfqueryparam value="#Form.Ccuenta#" cfsqltype="cf_sql_numeric">,
					<cfif isdefined("Form.CcuentaCxC") and len(trim(form.CcuentaCxC)) >
						CcuentaCxC 		= <cfqueryparam value="#Form.CcuentaCxC#" cfsqltype="cf_sql_numeric">,
					<cfelse>
						CcuentaCxC 		= null,
					</cfif>
					
					<cfif isdefined("Form.CcuentaCxCAcred") and len(trim(form.CcuentaCxCAcred))  >
						CcuentaCxCAcred 		= <cfqueryparam value="#Form.CcuentaCxCAcred#" cfsqltype="cf_sql_numeric">,
					<cfelse>
						CcuentaCxCAcred 		= null,
					</cfif>	
					
					<cfif isdefined("Form.CcuentaCxPAcred") and len(trim(form.CcuentaCxPAcred)) >
						CcuentaCxPAcred 		= <cfqueryparam value="#Form.CcuentaCxPAcred#" cfsqltype="cf_sql_numeric">,
					<cfelse>
						CcuentaCxPAcred 		= null,
					</cfif>				
					Icompuesto = 0,
					<cfif isdefined("Form.Icreditofiscal")>				
						Icreditofiscal = 1,
					<cfelse>
						Icreditofiscal = 0,
					</cfif>
				</cfif>
				
				Usucodigo = <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				Ifecha = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Icodigo = <cfqueryparam value="#Form.Icodigo#" cfsqltype="cf_sql_char">
		</cfquery> 
		<cfset modo="CAMBIO">
	
	</cfif>
</cfif>

<cfoutput>
<form action="<cfif isdefined("action")>#action#<cfelse>Impuestos.cfm</cfif>" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="Icodigo" type="hidden" value="<cfif isdefined("Form.Icodigo") and modo NEQ 'ALTA'>#Form.Icodigo#</cfif>">
</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


