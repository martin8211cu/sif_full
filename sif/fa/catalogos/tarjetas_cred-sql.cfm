<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FATarjetas"
		redirect="tarjetas_cred.cfm"
		timestamp="#form.ts_rversion#"
	
		field1="FATid"
		type1="numeric"
		value1="#form.FATid#"> 
				
	<cfquery name="update" datasource="#session.DSN#">
		update FATarjetas set       
         <cfif isdefined('form.FATcodigo') and len(trim(form.FATcodigo))>
		 FATcodigo = <cfqueryparam value="#Form.FATcodigo#" cfsqltype="cf_sql_varchar">,
         </cfif>
         <cfif isdefined('form.tc_tipo') and len(trim(form.tc_tipo))>
		 FATtipo = <cfqueryparam value="#Form.tc_tipo#" cfsqltype="cf_sql_char">,
         </cfif>
		 <cfif isdefined('form.FATtiptarjeta') and len(trim(form.FATtiptarjeta))>
         FATtiptarjeta = <cfqueryparam value="#Form.FATtiptarjeta#" cfsqltype="cf_sql_char">,
         </cfif>
         <cfif isdefined('form.FATdescripcion') and len(trim(form.FATdescripcion))>
		 FATdescripcion = <cfqueryparam value="#Form.FATdescripcion#" cfsqltype="cf_sql_varchar">,
         </cfif>
        <cfif not isdefined('form.FATcompuesta')>
			 <cfif isdefined('form.SNcodigo') and len(trim(form.SNcodigo))>
              SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">,
             </cfif>
             <cfif isdefined('form.FATporccom') and len(trim(form.FATporccom))>
                FATporccom = <cfqueryparam value="#Form.FATporccom#" cfsqltype="cf_sql_double">,
             <cfelse>
                FATporccom = 0,
             </cfif>				
             <cfif isdefined('form.CFcuentaCom') and len(trim(form.CFcuentaCom))>
                CFcuentaComision = <cfqueryparam value="#form.CFcuentaCom#" cfsqltype="cf_sql_numeric">,
             <cfelse>
                CFcuentaComision = null,
             </cfif>	
             <cfif isdefined('form.CFcuentaCobro') and len(trim(form.CFcuentaCobro))>
                CFcuentaCobro = <cfqueryparam value="#Form.CFcuentaCobro#" cfsqltype="cf_sql_numeric">,
             <cfelse>
                CFcuentaCobro = null,
            </cfif>
            <cfif isdefined('form.FATcomplemento') and len(trim(form.FATcomplemento))>
              FATcomplemento=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FATcomplemento#">,
            <cfelse>
             FATcomplemento= null,
            </cfif>  
            <cfif isdefined('form.GeneraCxP')>      
               FATcxpsocio = 1,
             <cfelse>
               FATcxpsocio = 0,
              </cfif>
               <cfif isdefined('form.AplicaMontos')>      
               FATaplicamontos = 1,
             <cfelse>
               FATaplicamontos = 0,
              </cfif>
              <cfif isdefined('form.MontoMax') and len(trim(form.MontoMax)) gt 0>
               FATmontomax= <cf_jdbcquery_param value="#replace(Form.MontoMax,',','','all')#" cfsqltype="cf_sql_money">, 
              </cfif> 
              <cfif isdefined('form.MontoMin') and len(trim(form.MontoMin)) gt 0>
               FATmontomin= <cf_jdbcquery_param value="#replace(Form.MontoMin,',','','all')#" cfsqltype="cf_sql_money">,
              </cfif> 
              <cfif isdefined('form.CFid') and len(trim(form.CFid)) gt 0>
               CFid=  <cfqueryparam value="#Form.CFid#" cfsqltype="cf_sql_numeric">,
              <cfelse>
              CFid=null,
              </cfif>
          <cfelse>
                FATporccom = 0,            
          </cfif>
          <cfif isdefined('form.FATcompuesta')>
            FATcompuesta = 1,
            <cfelse>
            FATcompuesta = 0,
          </cfif>
          <cfif isdefined('form.NosumaComision')>
            FATNOsumaComision = 1,
            <cfelse>
            FATNOsumaComision = 0,
          </cfif>
          <cfif isdefined('form.CFtarjeta')>
            FATCFtarjeta = 1,
            <cfelse>
            FATCFtarjeta = 0,
          </cfif>
          <cfif isdefined('form.CtaCobrotarjeta')>
            FATCtaCobrotarjeta = 1,
            <cfelse>
            FATCtaCobrotarjeta = 0,
          </cfif>
           <cfif isdefined('form.NoaplicaAnulacion')>
            FATNOaplicaAnulacion = 1,
            <cfelse>
            FATNOaplicaAnulacion = 0,
          </cfif>
          <cfif isdefined('form.FATvisible')>
            FATvisible = 1,
            <cfelse>
            FATvisible = 0,
          </cfif>          
          BTid= <cf_jdbcquery_param value="#form.BTid#" cfsqltype="cf_sql_numeric" null="#len(form.BTid) eq 0#">,
          CBid= <cf_jdbcquery_param value="#form.CBid#" cfsqltype="cf_sql_numeric" null="#len(form.CBid) eq 0#">,        
		BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FATid = <cfqueryparam value="#form.FATid#" cfsqltype="cf_sql_numeric">
	</cfquery> 

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
      delete from FATarjetas
	  where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FATid = <cfqueryparam value="#form.FATid#" cfsqltype="cf_sql_numeric">
    </cfquery>

<cfelseif IsDefined("form.Alta")>
<cfif isdefined('form.MontoMax') and form.MontoMax gt 0  and isdefined('form.MontoMin')  and form.MontoMin gt 0> 
    <cfif #replace(Form.MontoMin,',','','all')# gt #replace(Form.MontoMax,',','','all')# >
       <cfthrow message="El monto mínimo no puede ser mayor al monto Máximo. Favor corregir.">
    </cfif>
</cfif>

	<cfquery datasource="#session.dsn#">
		insert into FATarjetas ( Ecodigo, SNcodigo, FATcodigo, FATtipo, FATtiptarjeta, FATdescripcion, FATporccom, CFcuentaComision, CFcuentaCobro, BMUsucodigo, fechaalta,FATcomplemento,
        FATcxpsocio, FATaplicamontos, FATmontomax,FATmontomin,CFid,FATcompuesta,FATNOsumaComision,FATCFtarjeta,FATCtaCobrotarjeta,FATNOaplicaAnulacion,FATvisible,
        BTid, CBid)
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">, 
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FATcodigo#">, 
        <cfif isdefined('form.tc_tipo')>
				  <cfqueryparam cfsqltype="cf_sql_char" value="#form.tc_tipo#" null="#len(trim(form.tc_tipo)) is 0#">, 
        <cfelse> null, </cfif>
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.FATtiptarjeta#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FATdescripcion#">,
				<cfif isdefined('form.FATporccom') and form.FATporccom NEQ ''> 
				<cfqueryparam cfsqltype="cf_sql_double" value="#form.FATporccom#">, 
				<cfelse>
					0,
				</cfif>
				<cfif isdefined('form.CFcuentaCom') and form.CFcuentaCom NEQ ''> 
		        	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentaCom#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.CFcuentaCobro') and form.CFcuentaCobro NEQ ''> 
		        	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentaCobro#">,
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfif isdefined('form.FATcomplemento') and len(trim(form.FATcomplemento))>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FATcomplemento#">,
                <cfelse>
                    null,
                </cfif>   
                  <cfif isdefined('form.GeneraCxP')> 1 <cfelse> 0</cfif>,
                   <cfif isdefined('form.AplicaMontos')> 1 <cfelse>0 </cfif>,
                  <cfif isdefined('form.MontoMax') and len(trim(form.MontoMax)) gt 0>                  
                   <cf_jdbcquery_param value="#replace(Form.MontoMax,',','','all')#" cfsqltype="cf_sql_money">
                    <cfelse>0</cfif>,           
                  <cfif isdefined('form.MontoMin') and len(trim(form.MontoMin)) gt 0>                    
                     <cf_jdbcquery_param value="#replace(Form.MontoMin,',','','all')#" cfsqltype="cf_sql_money">
                    <cfelse>0</cfif>,                 
                  <cfif isdefined('form.CFid') and len(trim(form.CFid)) gt 0>
                  <cfqueryparam value="#Form.CFid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
                  <cfif isdefined('form.FATcompuesta')>
                     1
                   <cfelse>
                     0
                   </cfif>,
                   <cfif isdefined('form.NosumaComision')>
		             1
		           <cfelse>
		             0
		           </cfif>,
		           <cfif isdefined('form.CFtarjeta')>
		            1
		            <cfelse>
		            0
		          </cfif>,
		          <cfif isdefined('form.CtaCobrotarjeta')>
		            1
		            <cfelse>
		             0
		          </cfif>, 	
		          <cfif isdefined('form.NoaplicaAnulacion')>
                   1
                  <cfelse>
                   0
                  </cfif>,
                  <cfif isdefined('form.FATvisible')>
		           1
		            <cfelse>
		           0
		          </cfif>
              , <cf_jdbcquery_param value="#form.BTid#" cfsqltype="cf_sql_numeric" null="#len(form.BTid) eq 0#">
              , <cf_jdbcquery_param value="#form.CBid#" cfsqltype="cf_sql_numeric" null="#len(form.CBid) eq 0#">           
                 )
	</cfquery>
</cfif>

<cfif isdefined("form.btnCompuesta")>    
  <cfset ruta= "tarjetas_credDet-form.cfm">
<cfelse>
   <cfset ruta= "tarjetas_cred.cfm">
</cfif>

<form action="<cfoutput>#ruta#</cfoutput>" method="post" name="sql">
	<cfoutput>
	<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="FATid" type="hidden" value="#form.FATid#"> 	
		</cfif>
							
		<cfif isdefined('form.FATcodigo_F') and len(trim(form.FATcodigo_F))>
			<input type="hidden" name="FATcodigo_F" value="#form.FATcodigo_F#">	
		</cfif>
		
		<cfif isdefined('form.FATdescripcion_F') and len(trim(form.FATdescripcion_F))>
			<input type="hidden" name="FATdescripcion_F" value="#form.FATdescripcion_F#">	
		</cfif>	
        <cfif isdefined("form.btnCompuesta")>
        	<input type="hidden" name="tarjeta" value="#form.FATid#">	
        </cfif>		
	</cfoutput>
</form>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.sql.submit();</script>
	</body>
</html>