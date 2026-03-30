<cfif IsDefined("form.btnCambiar")>
	<cfparam name="form.CBid"				default="-1">
	<cfparam name="form.TESCBid"			default="-1">
	<cfparam name="form.CBidReintegrable"	default="-1">
	<cfquery datasource="#session.dsn#">
		insert into TEScuentasBancos
			(TESid, CBid, TESCBactiva, TESCBreintegrable)
		select #session.Tesoreria.TESid#
		  	,	CBid
			,	1
			,	case when CBid in (#form.CBidReintegrable#) then 1 else 0 end
		  from CuentasBancos
		 where CBid in (#form.CBid#, #form.CBidReintegrable#)
		   and CBid not in (#form.TESCBid#)
           and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		update TEScuentasBancos
		   set TESCBactiva		 = case when CBid in (#form.CBid#) 			   then 1 else 0 end
		     , TESCBreintegrable = case when CBid in (#form.CBidReintegrable#) then 1 else 0 end
		 where TESid = #session.Tesoreria.TESid#
		   and CBid in (#form.TESCBid#)
	</cfquery>
</cfif>		

<cflocation url="cuentasBancos.cfm">