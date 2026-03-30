<cfset data = "		select cb.CBid, cb.CBcodigo, cb.CBdescripcion, cb.Mcodigo, 
						m.Mnombre,
						round(
							coalesce(
							(	case 
								when cb.Mcodigo = e.Mcodigo then 1.00 
								else tc.TCcompra 
								end
							)
							, 1.00)
						,2) as EMtipocambio
					from CuentasBancos cb
					inner join Monedas m 
					on cb.Mcodigo = m.Mcodigo
					inner join Empresas e
					on e.Ecodigo = cb.Ecodigo
					left outer join Htipocambio tc
					on cb.Ecodigo = tc.Ecodigo
					and cb.Mcodigo = tc.Mcodigo
					and tc.Hfecha = (
						select max(tc1.Hfecha) 
						from Htipocambio tc1 
						where tc1.Ecodigo = tc.Ecodigo
						and tc1.Mcodigo = tc.Mcodigo
						and tc1.Hfecha <=  $EMfecha,date$
					)
					where cb.Ecodigo = 1 and cb.Bid = $Bid,numeric$ and cb.Ocodigo = $Ocodigo,numeric$ order by Mnombre, Hfecha
					">
<cfset url.Bid = 50><cfset url.Ocodigo = 25><cfset url.EMfecha = '17/08/2005'>
<cfset start = 1>
<cfset arr = ArrayNew(1)>
<cfloop from="1" to="10" index="xxxx">
	<cfoutput>start = #start# <br></cfoutput>
	<cfset algo = ReFind("\$([^,$]+),([a-z]+)\$",data,start,1)>
	<cfdump var="#algo#">
	<cfset struct = StructNew()>
	<cfif arraylen(algo.pos) GTE 3>
		<cfset StructInsert(struct, "txt", mid(data,start,algo.pos[1]-start))>
		<cfset StructInsert(struct, "val", HTMLEditFormat(url [trim(mid(data,algo.pos[2],algo.len[2]))]))>
		<cfset StructInsert(struct, "tip", trim(mid(data,algo.pos[3],algo.len[3])))>
	<cfelse>
		<cfset StructInsert(struct, "txt", mid(data,start,len(data)-start+1))>
		<cfset StructInsert(struct, "val", "")>
		<cfset StructInsert(struct, "tip", "")>
	</cfif>
	<cfdump var="#struct#">
	<cfset ArrayAppend(arr,struct)>
	<cfif arraylen(algo.pos) LT 3><cfbreak></cfif>
	<cfset start=algo.pos[1]+algo.len[1]>
</cfloop>

<cfset mx = arr>
<cfquery datasource="tramites" name="rs">
	<cfloop from="1" to="#ArrayLen(mx)#" index="i">
		<cfset xxxx = mx[i].txt>
		#PreserveSingleQuotes(xxxx)#
		<cfif len(mx[i].tip) gt 0 and len(mx[i].val) gt 0>
			<cfswitch expression="cf_sql_#mx[i].tip#">
				<cfcase value="cf_sql_date,cf_sql_timestamp">
					<cfqueryparam cfsqltype="cf_sql_#mx[i].tip#" value="#LSParseDateTime(mx[i].val)#"> {cf_sql_#mx[i].tip#,#LSParseDateTime(mx[i].val)#}
				</cfcase>
				<cfcase value="cf_sql_decimal,cf_sql_double,cf_sql_float,cf_sql_money,cf_sql_money4,cf_sql_real">
					<cfqueryparam cfsqltype="cf_sql_#mx[i].tip#" value="#Replace(trim(mx[i].val), ',', '','all')#">{cf_sql_#mx[i].tip#,#Replace(trim(mx[i].val), ',', '','all')#}
				</cfcase>
				<cfdefaultcase>
					<cfqueryparam cfsqltype="cf_sql_#mx[i].tip#" value="#(Trim(mx[i].val))#">{cf_sql_#mx[i].tip#,#(Trim(mx[i].val))#}
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</cfloop><cfabort>
</cfquery>