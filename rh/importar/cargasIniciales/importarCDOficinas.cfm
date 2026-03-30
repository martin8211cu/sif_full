
	<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
		<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
	</cf_dbtemp>


	<cfquery datasource="#session.DSN#" name="datos">
		select codigo,descripcion,#session.Ecodigo#   
		from #table_name#	
	</cfquery>

 	<cfset currentrow=0>
 <cftransaction>
	<cfloop query="datos">
		<cfset currentrow=currentrow+1>
			<cfquery datasource="#session.DSN#" name="existe">

				select CDRHHOficodigo,CDRHHOdescripcion,Ecodigo from CDRHHOficinas
					where CDRHHOficodigo = #codigo#
			</cfquery>
		<cfif existe.recordcount GT 0>

			<cfquery name = "rsinsertar" datasource = "#session.dsn#" >
				insert into #errores# (Error)
		     	 values ('Error. El codigo del Oficina (#existe.CDRHHOdescripcion#) YA Existe en catalogo de Oficinas')
			</cfquery>
	   	<cfelse>

	   		<cfquery datasource="#session.DSN#">
				insert into CDRHHOficinas ( CDRHHOficodigo,CDRHHOdescripcion,Ecodigo) values( #codigo#,'#descripcion#',#session.Ecodigo#)
			</cfquery>
	     </cfif>
	</cfloop>
		 <cfquery name="rsErrores" datasource="#session.DSN#">
	    	select count(1) as cantidad
	    	from #errores#
	    </cfquery>

	    <cfif rsErrores.cantidad GT 0>
	    	<cfquery name="ERR" datasource="#session.DSN#">
	    		select Error as MSG
	    		from #errores#
	    		group by Error
	  		</cfquery>
    <cfreturn>
		</cfif>
 <cftransaction action="commit"/>
</cftransaction>

