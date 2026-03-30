<!--- <cfdump var="#url#"> --->
<cfset nameForm = "">
<cfif isdefined("Url.nameForm") and Len(Trim(Url.nameForm)) and not isdefined("Form.nameForm")>
	<cfset Form.nameForm = Url.nameForm>
</cfif>
<cfif isdefined("Form.nameForm") and Len(Trim(Form.nameForm))>
	<cfset nameForm = Form.nameForm>
<cfelse>
	<cfset nameForm = 'form1'>
</cfif>
<cfif isdefined("url.ETconsecutivo") and len(trim(url.ETconsecutivo))>
	<cfquery name="rs" datasource="sifpublica">
		select 	ETidtracking,
				ETnumtracking,
				ETconsecutivo	
		from ETracking
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ETconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ETconsecutivo#">
		  <cfif not(isdefined("url.todoEstado") and url.todoEstado eq 1)>
		  and ETestado <> 'E'
		  </cfif>
	</cfquery>

	<script language="javascript1.2" type="text/javascript">
		<cfif rs.recordCount gt 0>
			<cfoutput>
			window.parent.document.#nameForm#.ETidtracking_move#url.index#.value = #rs.ETidtracking#;
			window.parent.document.#nameForm#.ETconsecutivo_move#url.index#.value = #rs.ETconsecutivo#;
			window.parent.document.#nameForm#.ETnumtracking_move#url.index#.value = '#JSStringFormat(rs.ETnumtracking)#';
			</cfoutput>
		<cfelse>
			<cfoutput>
			window.parent.document.#nameForm#.ETidtracking_move#url.index#.value = '';
			window.parent.document.#nameForm#.ETconsecutivo_move#url.index#.value = '';
			window.parent.document.#nameForm#.ETnumtracking_move#url.index#.value = '';
			</cfoutput>
		</cfif>
	</script>
</cfif>
