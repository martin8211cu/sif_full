<cfif isdefined("form.SDetalle")>
	<cfset LvarDetalle = form.SDetalle>
<cfelse>
	<cfset LvarDetalle = 1> <!---Para No Mostrar los Detalles --->
</cfif>

<cf_templateheader title="Consulta Mascaras al Plan Contable">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Mascaras al Plan de Cuentas'>
			<cfif LvarDetalle EQ 1>
	            <cfquery name="rsReporte" datasource="#session.DSN#">
					select distinct e.PCEMcodigo,e.PCEMdesc,e.PCEMformato
					from PCEMascaras e 
						inner join PCNivelMascara d
						on e.PCEMid = d.PCEMid
					<cfif isdefined("session.CEcodigo") and session.CEcodigo NEQ "" and session.CEcodigo NEQ 0>
						where e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
					</cfif>
					order by PCEMcodigo --,d.PCNid
    	        </cfquery>
            <cfelse>
            	<cfquery name="rsReporte" datasource="#session.DSN#">
					select  e.PCEMcodigo,e.PCEMdesc,e.PCEMformato,d.PCNid, d.PCNdescripcion
					from PCEMascaras e 
						inner join PCNivelMascara d
						on e.PCEMid = d.PCEMid
					<cfif isdefined("session.CEcodigo") and session.CEcodigo NEQ "" and session.CEcodigo NEQ 0>
						where e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
					</cfif>
					order by PCEMcodigo ,d.PCNid
		        </cfquery>
            </cfif>
			<cfoutput>
	        	<form id="form1" name="form1" method="post" action="ConsultaMascaras.cfm">
    	        	<label>
        	      		<input type="radio" name="SDetalle" id="0" value="1" <cfif LvarDetalle EQ 1> checked </cfif> onclick="submit()" />
               		 	Sin Detalles</label>
	              	<label>
      		  			<input type="radio" name="SDetalle" id="1" value="2" <cfif LvarDetalle NEQ 1> checked </cfif> onclick="submit()"/>
                		Con Detalles</label>  
	  		  </form>
            </cfoutput>
            <cfif LvarDetalle EQ 1>
	            <center>
	                <table width="80%" cellpadding="2" cellspacing="10" >
	   	  		  <tr>
        		           	<td bgcolor="#CCCCCC" bordercolor="#000000" align="center" width="20%"> Codigo Mascara </td>
            		      	<td align="center" width="40%"> Descripcion Mascara </td>
                			<td bgcolor="#CCCCCC" bordercolor="#000000" align="center" width="40%"> Mascara </td>
	            		</tr>
	    	        </table>
              </center>
            <cfelse>
            	<center>
		           <table width="80%" border="1" cellpadding="2" cellspacing="8">
				   		<tr>
		        	       	<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="60%"> Descripcion </td>
        		         	<td align="center"  width="40%"> Nivel </td>
	           			</tr>
		   		  </table>
        		</center> 	
            </cfif>
			<hr color="#333333" style="border:groove" /> 
			<cfoutput query="rsReporte" group="PCEMcodigo">
				<cfif LvarDetalle EQ 1>
                	<center>
	                   	<table width="80%" border="1" cellpadding="2" cellspacing="10">
							<tr nowrap="nowrap" >
       		           			<td bgcolor="CCCCCC" bordercolor="000000" align="center" with="20%"> #PCEMcodigo# </td>
	        	    	      	<td align="center" width="40%"> #PCEMdesc# </td>
   		        	    		<td bgcolor="CCCCCC" bordercolor="000000" align="right" width="40%"> #PCEMformato# </td>
    		        		</tr>
	   			      	</table>
                   	</center>
    		   	<cfelse>
	            	<pre> <strong>#PCEMcodigo#</strong>, #PCEMdesc#
						Mascara: #PCEMformato# </pre>
					<cfoutput>
	        	    	<center>
	                        <table border="1" cellpadding="2" cellspacing="8" width="80%">
								<tr nowrap="nowrap" >
        	   	    				<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="60%"> #PCNdescripcion# </td>
            	    	        		<td align="center" width="40%"> #PCNid# </td>
                	          	</tr>
		    	    	    </table>
                       	</center>
    		        </cfoutput>
                </cfif>
	   	    </cfoutput>

	<cf_web_portlet_end>
<cf_templatefooter>