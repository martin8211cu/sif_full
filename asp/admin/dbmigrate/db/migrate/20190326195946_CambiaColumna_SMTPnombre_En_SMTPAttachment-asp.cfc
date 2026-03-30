<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="CambiaColumna_SMTPnombre_En_SMTPAttachment">
  <cffunction name="up">
    <cfscript>
      execute('
              alter table SMTPAttachment drop constraint SMTPAttachment_PK
              ALTER TABLE SMTPAttachment alter column SMTPnombre varchar(255) not null
              ALTER TABLE SMTPAttachment ADD CONSTRAINT SMTPAttachment_PK PRIMARY KEY ([SMTPid] ASC,[SMTPnombre] ASC)
              ');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('
              alter table SMTPAttachment drop constraint SMTPAttachment_PK
              ALTER TABLE SMTPAttachment alter column SMTPnombre varchar(60) not null
              ALTER TABLE SMTPAttachment ADD CONSTRAINT SMTPAttachment_PK PRIMARY KEY ([SMTPid] ASC,[SMTPnombre] ASC)
  			');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
