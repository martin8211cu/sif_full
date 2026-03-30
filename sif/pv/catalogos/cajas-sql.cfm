 <cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="FAM001"
				redirect="cajas.cfm"
				timestamp="#form.ts_rversion#"
				field1="FAM01COD"
				type1="char"
				value1="#form.FAM01COD#">
				
					
	<cfquery name="update" datasource="#session.DSN#">
		update FAM001 set
		FAM01CODD = <cfqueryparam value="#Form.FAM01CODD#" cfsqltype="cf_sql_char">,
		FAM09MAQ = <cfqueryparam value="#Form.FAM09MAQ#" cfsqltype="cf_sql_tinyint">,
		FAM01DES = <cfqueryparam value="#Form.FAM01DES#" cfsqltype="cf_sql_varchar">,
		FAM01RES = <cfqueryparam value="#Form.FAM01RES#" cfsqltype="cf_sql_varchar">,
		FAM01TIP = <cfqueryparam value="#Form.FAM01TIP#" cfsqltype="cf_sql_tinyint">,
		FAM01COB = <cfqueryparam value="#Form.FAM01COB#" cfsqltype="cf_sql_smallint">,
		FAM01STS = <cfqueryparam value="#Form.FAM01STS#" cfsqltype="cf_sql_bit">,
		FAM01STP = <cfqueryparam value="#Form.FAM01STP#" cfsqltype="cf_sql_tinyint">,
		<cfif isdefined('form.Ccuenta') and form.Ccuenta NEQ ''>
		  Ccuenta = <cfqueryparam value="#Form.Ccuenta#" cfsqltype="cf_sql_numeric">,
		<cfelse>
		  Ccuenta =null,
		</cfif>
		I02MOD = <cfqueryparam value="#Form.IO2MOD#" cfsqltype="cf_sql_bit">,
		CCTcodigoAP = <cfqueryparam value="#Form.CCTcodigoAP#" cfsqltype="cf_sql_char">,
		CCTcodigoDE = <cfqueryparam value="#Form.CCTcodigoDE#" cfsqltype="cf_sql_char">,
		CCTcodigoFC = <cfqueryparam value="#Form.CCTcodigoFC#" cfsqltype="cf_sql_char">,
		CCTcodigoCR = <cfqueryparam value="#Form.CCTcodigoCR#" cfsqltype="cf_sql_char">,
		CCTcodigoRC = <cfqueryparam value="#Form.FAM01CODD#" cfsqltype="cf_sql_char">,
		<cfif isdefined('form.FAM01NPR') and form.FAM01NPR NEQ ''>
		   FAM01NPR = <cfqueryparam value="#Form.FAM01NPR#" cfsqltype="cf_sql_varchar">,
		<cfelse>
		   FAM01NPR = null,
		</cfif>
		<cfif isdefined('form.FAM01NPA') and form.FAM01NPA NEQ ''>
		  FAM01NPA = <cfqueryparam value="#Form.FAM01NPA#" cfsqltype="cf_sql_varchar">,
		<cfelse>
		  FAM01NPA = null,
		</cfif>
		<cfif isdefined('form.AID') and form.AID NEQ ''>
		  Aid = <cfqueryparam value="#Form.Aid#" cfsqltype="cf_sql_numeric">,
		<cfelse>
		  Aid =null,
		</cfif>
		<cfif isdefined('form.Mcodigo') and form.Mcodigo NEQ ''>
		  Mcodigo = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">,
		<cfelse>
		  Mcodigo =null,
		</cfif>
		FAM01TIF = <cfqueryparam value="#Form.FAM01TIF#" cfsqltype="cf_sql_char">,
		<cfif isdefined('form.FAPDES') and form.FAPDES NEQ ''>
		  FAPDES = <cfqueryparam value="#Form.FAPDES#" cfsqltype="cf_sql_char">,
		<cfelse>
		  FAPDES =null,
		</cfif>
		FAM01CTP = 0,
		FAM01AUT = 0,
		BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAM01COD = <cfqueryparam value="#Form.FAM01COD#" cfsqltype= "cf_sql_char">
		
	</cfquery> 

	<cflocation url="cajas.cfm?FAM001=#form.FAM01COD#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
      delete from FAM001
	  where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	  and FAM01COD = <cfqueryparam cfsqltype= "cf_sql_char" value="#Form.FAM01COD#">
	</cfquery>
 	

<!--- suma 1 al max de cod identity char --->
<cfelseif IsDefined("form.Alta")>

	<cfquery name="rsSiguiente" datasource="#session.dsn#">
		Select coalesce(max(convert(numeric, FAM01COD)), 0)+1 as valor
		from FAM001
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	</cfquery> 

	<cfquery datasource="#session.dsn#">
		insert into FAM001 ( Ecodigo, Ocodigo, FAM01COD, FAM01CODD, FAM09MAQ, FAM01DES, FAM01RES, FAM01TIP,
		   FAM01COB, FAM01STS, FAM01STP,Ccuenta, I02MOD, CCTcodigoAP,CCTcodigoDE, CCTcodigoFC, 
		   CCTcodigoCR, CCTcodigoRC, FAM01NPR, FAM01NPA,Aid, Mcodigo,FAM01TIF,FAPDES, 
		   BMUsucodigo, fechaalta, FAM01CTP, FAM01AUT)
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		<cfif isdefined('form.Ocodigo') and form.Ocodigo NEQ ''>
			<cfqueryparam cfsqltype= "cf_sql_integer" value="#form.Ocodigo#">,
		<cfelse>
			null,
		</cfif>		
		<cfqueryparam cfsqltype= "cf_sql_char" value="#rsSiguiente.valor#">,
		<cfqueryparam cfsqltype= "cf_sql_char" value="#form.FAM01CODD#">,
		<cfqueryparam cfsqltype= "cf_sql_tinyint" value="#form.FAM09MAQ#">,
		<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM01DES#">,
		<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM01RES#">, 
		<cfqueryparam cfsqltype= "cf_sql_tinyint" value="#form.FAM01TIP#">, 
		<cfqueryparam cfsqltype= "cf_sql_smallint" value="#form.FAM01COB#">,
		<cfqueryparam cfsqltype= "cf_sql_bit" value="#form.FAM01STS#">,
		<cfqueryparam cfsqltype= "cf_sql_tinyint" value="#form.FAM01STP#">,
		<cfif isdefined('form.Ccuenta') and form.Ccuenta NEQ ''>
		   <cfqueryparam cfsqltype= "cf_sql_numeric" value="#form.Ccuenta#">,
		<cfelse>
			null,
		</cfif>
		<cfqueryparam cfsqltype= "cf_sql_bit" value="#form.IO2MOD#">,
		<cfqueryparam cfsqltype= "cf_sql_char" value="#form.CCTcodigoAP#">,
		<cfqueryparam cfsqltype= "cf_sql_char" value="#form.CCTcodigoDE#">, 
		<cfqueryparam cfsqltype= "cf_sql_char" value="#form.CCTcodigoFC#">,
		<cfqueryparam cfsqltype= "cf_sql_char" value="#form.CCTcodigoCR#">,
		<cfqueryparam cfsqltype= "cf_sql_char" value="#form.CCTcodigoRC#">,
		<cfif isdefined('form.FAM01NPR') and form.FAM01NPR NEQ ''>
			<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM01NPR#">,
		<cfelse>
			null,
		</cfif>
		<cfif isdefined('form.FAM01NPA') and form.FAM01NPA NEQ ''>
			<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAM01NPA#">,
		<cfelse>
			null,
		</cfif>
		<cfif isdefined('form.AID') and form.AID NEQ ''>
			<cfqueryparam cfsqltype= "cf_sql_numeric" value="#form.AID#">,
		<cfelse>
			null,
		</cfif>
		<cfif isdefined('form.Mcodigo') and form.Mcodigo NEQ ''>
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
	    <cfelse>
			null,
		</cfif>
		<cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM01TIF#">,
		
		<cfif isdefined('form.FAPDES') and form.FAPDES NEQ ''>
			<cfqueryparam cfsqltype= "cf_sql_char" value="#form.FAPDES#">,
		<cfelse>
			null,
		</cfif>
	    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		0,0)
	</cfquery>
</cfif>

<cflocation url="cajas.cfm">