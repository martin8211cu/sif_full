<cfset params="">
<cfif IsDefined("form.Cambio")>

	<cfquery name="update" datasource="#session.DSN#">
		update FAM001 set
		    Ocodigo = <cfif isdefined("form.Ocodigo") and form.Ocodigo NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_integer" value="#form.Ocodigo#">,
			<cfelse>
				null,
			</cfif>		
			FAM01CODD = <cfqueryparam value="#Form.FAM01CODD#" cfsqltype="cf_sql_char">,
			FAM09MAQ = <cfqueryparam value="#Form.FAM09MAQ#" cfsqltype="cf_sql_tinyint">,
			FAM01DES = <cfqueryparam value="#Form.FAM01DES#" cfsqltype="cf_sql_varchar">,
			FAM01RES = <cfqueryparam value="#Form.FAM01RES#" cfsqltype="cf_sql_varchar">,
			FAM01TIP = <cfqueryparam value="#Form.FAM01TIP#" cfsqltype="cf_sql_tinyint">,
			FAM01COB = <cfqueryparam value="#Form.FAM01COB#" cfsqltype="cf_sql_smallint">,
			FAM01STS = <cfqueryparam value="#Form.FAM01STS#" cfsqltype="cf_sql_bit">,
			FAM01STP = <cfqueryparam value="#Form.FAM01STP#" cfsqltype="cf_sql_tinyint">,
			<cfif isdefined("Form.CFcuenta1") and Form.CFcuenta1 NEQ "">
				CFcuenta = <cfqueryparam value="#Form.CFcuenta1#" cfsqltype="cf_sql_numeric">,
			<cfelse>
				CFcuenta =null,
			 </cfif>
			 <cfif isdefined("Form.CFcuentaSobrantes") and Form.CFcuentaSobrantes NEQ "">
				CFcuentaSobrantes = <cfqueryparam value="#Form.CFcuentaSobrantes#" cfsqltype="cf_sql_numeric">,
			<cfelse>
				CFcuentaSobrantes =null,
			</cfif>
			<cfif isdefined("Form.CFcuentaFaltantes") and Form.CFcuentaFaltantes NEQ "">
				CFcuentaFaltantes = <cfqueryparam value="#Form.CFcuentaFaltantes#" cfsqltype="cf_sql_numeric">,
			<cfelse>
				CFcuentaFaltantes =null,
			 </cfif>
			I02MOD = <cfif isdefined("form.IO2MOD")> 1, <cfelse> 0, </cfif>
			<cfif isdefined("form.CalculoDesc")> 
				CalculoDesc = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CalculoDesc#">,
			<cfelse> CalculoDesc = 0,</cfif>			
			CCTcodigoAP = <cfqueryparam value="#Form.CCTcodigoAP#" cfsqltype="cf_sql_char">,
			CCTcodigoDE = <cfqueryparam value="#Form.CCTcodigoDE#" cfsqltype="cf_sql_char">,
			CCTcodigoFC = <cfqueryparam value="#Form.CCTcodigoFC#" cfsqltype="cf_sql_char">,
			CCTcodigoCR = <cfqueryparam value="#Form.CCTcodigoCR#" cfsqltype="cf_sql_char">,
			CCTcodigoRC = <cfqueryparam value="#Form.CCTcodigoRC#" cfsqltype="cf_sql_char">,
			<cfif isdefined("form.FAM01NPR") and form.FAM01NPR NEQ "">
				FAM01NPR = <cfqueryparam value="#Form.FAM01NPR#" cfsqltype="cf_sql_varchar">,
			<cfelse>
				FAM01NPR = null,
			</cfif>
			<cfif isdefined("form.FAM01NPA") and form.FAM01NPA NEQ "">
				FAM01NPA = <cfqueryparam value="#Form.FAM01NPA#" cfsqltype="cf_sql_varchar">,
			<cfelse>
				FAM01NPA = null,
			</cfif>
			<cfif isdefined("form.FAM01NPTP") and form.FAM01NPTP NEQ "">
				FAM01NPTP = <cfqueryparam value="#Form.FAM01NPTP#" cfsqltype="cf_sql_varchar">,
			<cfelse>
				FAM01NPTP = null,
			</cfif>
			
			<cfif isdefined("form.AID") and form.AID NEQ "">
				Aid = <cfqueryparam value="#Form.Aid#" cfsqltype="cf_sql_numeric">,
			<cfelse>
				Aid =null,
			</cfif>
			<cfif isdefined("form.Mcodigo") and form.Mcodigo NEQ "">
				Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">,
			</cfif>
			<cfif isdefined("form.CFid") and form.CFid NEQ "">
				CFid = <cfqueryparam value="#Form.CFid#" cfsqltype="cf_sql_numeric">,
			<cfelse>
				CFid = null,
			</cfif>
			FAM01TIF = <cfqueryparam value="#Form.FAM01TIF#" cfsqltype="cf_sql_char">,
			FAPDES = <cfif isdefined("form.FAPDES")>
					 	<cfqueryparam value="1" cfsqltype="cf_sql_char">,
					<cfelse>
						<cfqueryparam value="0" cfsqltype="cf_sql_char">,
					</cfif>
			FAM01CTP = 0,
			FAM01AUT = 0,
			BMUsucodigo= #session.Usucodigo#,
			FAX01ORIGEN = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX01ORIGEN_E#"> 
			where Ecodigo = #session.Ecodigo# 
			and FAM01COD = <cfqueryparam value="#Form.FAM01COD#" cfsqltype= "cf_sql_char">
	</cfquery>

<!---Elimina la Caja--->	
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from FAM001
		where Ecodigo = #session.Ecodigo# 
		and FAM01COD = <cfqueryparam cfsqltype= "cf_sql_char" value="#Form.FAM01COD#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
     	 delete from FAM001D
	  	 where Ecodigo = #session.Ecodigo# 
	     and FAM01COD = <cfqueryparam value="#Form.FAM01COD#" cfsqltype="cf_sql_char">
	</cfquery>
	
<cfelseif IsDefined("form.Eliminar")>
		<cfquery datasource="#session.dsn#">
     	 delete from FAM001D
	  	 where Ecodigo = #session.Ecodigo# 
	     and FAM01COD = <cfqueryparam value="#Form.FAM01COD#" cfsqltype="cf_sql_char">
		 and CCTcodigo = <cfqueryparam value="#Form.CCTcodigo#" cfsqltype="cf_sql_char">
		 and FAX01ORIGEN = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX01ORIGEN#">
	</cfquery>

<cfelseif IsDefined("form.Agregar")>
	<!---Verifica si ya existe--->
	<cfquery datasource="#session.dsn#" name="FAM001D">
     	 select count(1) as cantidad
		 from FAM001D
	  	 where Ecodigo   = #session.Ecodigo# 
	     and FAM01COD    = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.FAM01COD#" >
		 and CCTcodigo   = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#" >
		 and FAX01ORIGEN = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX01ORIGEN#">
	</cfquery>
	<cfif FAM001D.cantidad GT 0>
		<script language="JavaScript1.2" type="text/javascript">alert('El Formatos por Tipos de Documentos ya existe')</script>
	<cfelse>
	<cfquery datasource="#session.dsn#">
		insert into FAM001D( Ecodigo, FAM01COD,FMT01COD, CCTcodigo, BMUsucodigo, fechaalta, FAX01ORIGEN )
		values(	#session.Ecodigo#,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#form.FAM01COD#">,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#form.FMT01COD#">,
				<cfqueryparam cfsqltype= "cf_sql_char" value="#form.CCTcodigo#">,
				#session.Usucodigo#,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX01ORIGEN#"> )
	</cfquery>			
	</cfif>
	
	
<cfelseif IsDefined("form.Alta")>
	<cfquery name="rsSiguiente" datasource="#session.dsn#">
		<!---Select (max(coalesce(<cf_dbfunction name="to_number" args="FAM01COD">,0))+1) as valor--->
		Select coalesce(max(convert(numeric(18,0), FAM01COD)), 0) + 1 as valor
		from FAM001
		<!--- where Ecodigo = #session.Ecodigo#  --->
	</cfquery> 

	<cfif isdefined('rsSiguiente') and rsSiguiente.valor GT 0>
		<cfset form.FAM01COD = rsSiguiente.valor>
	<cfelse>
		<cfset form.FAM01COD = 1>
	</cfif>

	<cfquery datasource="#session.dsn#">
		insert into FAM001 ( 
			Ecodigo, Ocodigo, FAM01COD, FAM01CODD, FAM09MAQ, FAM01DES, FAM01RES, FAM01TIP,
			FAM01COB, FAM01STS, FAM01STP,CFcuenta, I02MOD, CalculoDesc, CCTcodigoAP,CCTcodigoDE, CCTcodigoFC, 
			CCTcodigoCR, CCTcodigoRC, FAM01NPR, FAM01NPA,FAM01NPTP, Aid, Mcodigo, CFid, FAM01TIF, FAPDES, 
			BMUsucodigo, fechaalta, FAM01CTP, FAM01AUT, CFcuentaSobrantes, CFcuentaFaltantes, FAX01ORIGEN)
		values(	
			#session.Ecodigo#,
			<cfif isdefined("form.Ocodigo") and form.Ocodigo NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_integer" value="#form.Ocodigo#">,
			<cfelse>
				null,
			</cfif>		
			<cfqueryparam cfsqltype= "cf_sql_char" value="#form.FAM01COD#">,
			<cfqueryparam cfsqltype= "cf_sql_char" value="#form.FAM01CODD#">,
			<cfqueryparam cfsqltype= "cf_sql_tinyint" value="#form.FAM09MAQ#">,
			<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM01DES#">,
			<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM01RES#">, 
			<cfqueryparam cfsqltype= "cf_sql_tinyint" value="#form.FAM01TIP#">, 
			<cfqueryparam cfsqltype= "cf_sql_smallint" value="#form.FAM01COB#">,
			<cfqueryparam cfsqltype= "cf_sql_bit" value="#form.FAM01STS#">,
			<cfqueryparam cfsqltype= "cf_sql_tinyint" value="#form.FAM01STP#">,
			<cfif isdefined("Form.CFcuenta1") and Form.CFcuenta1 NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_numeric" value="#Form.CFcuenta1#">,
			<cfelse>
				null,
			</cfif>
			<cfif isdefined("form.IO2MOD")> 1,<cfelse> 0,</cfif>
			<cfif isdefined("form.CalculoDesc")> 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CalculoDesc#">,
			<cfelse> 0,</cfif>
			<!---<cfqueryparam cfsqltype= "cf_sql_bit" value="#form.IO2MOD#">,--->
			<cfqueryparam cfsqltype= "cf_sql_char" value="#form.CCTcodigoAP#">,
			<cfqueryparam cfsqltype= "cf_sql_char" value="#form.CCTcodigoDE#">, 
			<cfqueryparam cfsqltype= "cf_sql_char" value="#form.CCTcodigoFC#">,
			<cfqueryparam cfsqltype= "cf_sql_char" value="#form.CCTcodigoCR#">,
			<cfqueryparam cfsqltype= "cf_sql_char" value="#form.CCTcodigoRC#">,
			<cfif isdefined("form.FAM01NPR") and form.FAM01NPR NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM01NPR#">,
			<cfelse>
				null,
			</cfif>
			<cfif isdefined("form.FAM01NPA") and form.FAM01NPA NEQ "">
			<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM01NPA#">,
			<cfelse>
				null,
			</cfif>
			
			<cfif isdefined("form.FAM01NPTP") and form.FAM01NPTP NEQ "">
			<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM01NPTP#">,
			<cfelse>
				null,
			</cfif>
			
			<cfif isdefined("form.AID") and form.AID NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_numeric" value="#form.AID#">,
			<cfelse>
				null,
			</cfif>
			<cfif isdefined("form.Mcodigo") and form.Mcodigo NEQ "">
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
			<cfelse>
				null,
			</cfif>
			<cfif isdefined("form.CFid") and form.CFid NEQ "">
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
			<cfelse>
				null,
			</cfif>			
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM01TIF#">,
			<cfif isdefined("form.FAPDES")>
				<cfqueryparam value="1" cfsqltype="cf_sql_char">,
			<cfelse>
				<cfqueryparam value="0" cfsqltype="cf_sql_char">,
			</cfif>

			#session.Usucodigo#,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			0, 0,
			<cfif isdefined("Form.CFcuentaSobrantes") and Form.CFcuentaSobrantes NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_numeric" value="#Form.CFcuentaSobrantes#">,
			<cfelse>
				null,
			</cfif>
			<cfif isdefined("Form.CFcuentaFaltantes") and Form.CFcuentaFaltantes NEQ "">
				<cfqueryparam cfsqltype= "cf_sql_numeric" value="#Form.CFcuentaFaltantes#">
			<cfelse>
				null
			</cfif>
			,<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAX01ORIGEN_E#">
		)
	</cfquery>
</cfif>

<form action="cajasProceso.cfm" method="post" name="sql">
	<cfoutput>
		<input name="FAM09MAQ" type="hidden" value="#form.FAM09MAQ#"> 
		<input name="Paso" type="hidden" value= "3">
		<cfif isdefined("Form.Agregar") or IsDefined ("Form.Eliminar") and not isDefined("Form.Baja") and not isDefined("Form.Nuevo")and not IsDefined("Form.Cambio")>
		   <input name="FAM01COD" type="hidden" value="#form.FAM01COD#"> 
		   <input name="CCTcodigo" type="hidden" value="#Form.CCTcodigo#">
		<cfelseif (isdefined("Form.Cambio") or IsDefined ("Form.Alta") or IsDefined ("Form.NuevoFD")) and not Isdefined ("Form.Baja") and not isDefined("Form.Nuevo")>
			<input name="FAM01COD" type="hidden" value="#form.FAM01COD#"> 
		</cfif>
		
	</cfoutput>
</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>