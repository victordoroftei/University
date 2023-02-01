/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_ANALIZATOR_S_TAB_H_INCLUDED
# define YY_YY_ANALIZATOR_S_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    ID = 258,                      /* ID  */
    ID_SIMPLU = 259,               /* ID_SIMPLU  */
    CONST_STRING = 260,            /* CONST_STRING  */
    CONST_INT = 261,               /* CONST_INT  */
    CONST_FLOAT = 262,             /* CONST_FLOAT  */
    MAIN = 263,                    /* MAIN  */
    PD = 264,                      /* PD  */
    PI = 265,                      /* PI  */
    AD = 266,                      /* AD  */
    AI = 267,                      /* AI  */
    PV = 268,                      /* PV  */
    INT = 269,                     /* INT  */
    FLOAT = 270,                   /* FLOAT  */
    STRUCT = 271,                  /* STRUCT  */
    VIRGULA = 272,                 /* VIRGULA  */
    EGAL = 273,                    /* EGAL  */
    PLUS = 274,                    /* PLUS  */
    MINUS = 275,                   /* MINUS  */
    INMUL = 276,                   /* INMUL  */
    DIV = 277,                     /* DIV  */
    MOD = 278,                     /* MOD  */
    CIN = 279,                     /* CIN  */
    COUT = 280,                    /* COUT  */
    OP_INP = 281,                  /* OP_INP  */
    OP_OUT = 282,                  /* OP_OUT  */
    IF = 283,                      /* IF  */
    ELSE = 284,                    /* ELSE  */
    MIC = 285,                     /* MIC  */
    MARE = 286,                    /* MARE  */
    EGAL_EGAL = 287,               /* EGAL_EGAL  */
    DIFERIT = 288,                 /* DIFERIT  */
    AND = 289,                     /* AND  */
    OR = 290,                      /* OR  */
    WHILE = 291,                   /* WHILE  */
    CATTIMP = 292,                 /* CATTIMP  */
    EXECUTA = 293,                 /* EXECUTA  */
    SFCATTIMP = 294                /* SFCATTIMP  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_ANALIZATOR_S_TAB_H_INCLUDED  */
