% ============================================================================
% == Class definition ==
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lettertemplate}[Template lettre, v1.0]
\LoadClass{article}

% ============================================================================
% == Packages ==
\RequirePackage[utf8]{inputenc}
\RequirePackage{graphicx}
\RequirePackage{caption}
\RequirePackage{subcaption}
\RequirePackage[T1]{fontenc}
\RequirePackage{enumitem}
\RequirePackage{fancyhdr}
\RequirePackage{tabularx}
\RequirePackage[left=2cm,right=2cm,bottom=2cm, top=2cm]{geometry}
\RequirePackage{etoolbox}
\RequirePackage{datetime}
\RequirePackage{array}
\RequirePackage{calc}
\RequirePackage{titletoc}
\RequirePackage{hyperref}
\RequirePackage{xstring}

% ============================================================================
% == Class options ==
\newbool{CoverLetter}
\boolfalse{CoverLetter}
\DeclareOption{CoverLetter}{\booltrue{CoverLetter}}

\newbool{fr}
\boolfalse{fr}
\DeclareOption{fr}{\booltrue{fr}}

\newbool{en}
\boolfalse{en}
\DeclareOption{en}{\booltrue{en}}

\ProcessOptions

% ============================================================================
% == Packages that depends on class option ==

\ifbool{fr}
    {
        \RequirePackage[french]{babel}
    }{
        \RequirePackage[english]{babel}
    }

% ============================================================================
% == Constants ==

\def\SenderFirstName{}
\def\SenderLastName{}
\def\SenderAddress{}
\def\SenderCityCode{}
\def\SenderCity{}
\def\SenderPhone{}
\def\SenderEmail{}

\def\ReceiverFirstName{}
\def\ReceiverLastName{}
\def\ReceiverAddress{}
\def\ReceiverCityCode{}
\def\ReceiverCity{}
\def\ReceiverDescription{}
\def\ReceiverCompany{}

\def\SendingPlace{}

\def\Object{}
\def\Attachment{}

% ============================================================================
% == Style ==

\pagestyle{empty}

% ============================================================================
% == Commands ==

\newcommand{\Format}[1]{%
    \StrLeft{#1}{1}[\FirstLetter]%
    \StrGobbleLeft{#1}{1}[\Rest]%
    \MakeUppercase{\FirstLetter}\MakeLowercase{\Rest}%
}
\newcommand{\Capitalize}[1]{\MakeUppercase{#1}}

\newcommand{\FormatFirstName}[1]{\Format{#1}}
\newcommand{\FormatLastName}[1]{\Capitalize{#1}}
\newcommand{\FormatCity}[1]{\Format{#1}}
\newcommand{\CapitalizeCity}[1]{\Capitalize{#1}}

\newcommand{\SetSpace}[1]{%
    \ifboolexpr{
        (test {\ifbool{fr}} and
        test {\ifstrequal{#1}{Receiver}}) or
        (test {\ifbool{en}} and
        test {\ifstrequal{#1}{Sender}})
    }
    {\hspace{0.54\textwidth}}%
    {}%
}

\newcommand{\Stakeholder}[8]{
    \noindent
    \SetSpace{#1}%
    \begin{minipage}[t]{0.45\textwidth}
        \ifthenelse { \equal{#2}{} \and \equal{#3}{} }
            {}
            {\noindent\textbf{\FormatFirstName{#2} \FormatLastName{#3}}}
        
        \ifthenelse { \equal{#1}{Receiver} }
            {
                \ifthenelse { \equal{#7}{} } {} {\textbf{#7}}

                \ifboolexpr{
                    test {\ifbool{CoverLetter}} and
                    test {\ifstrequal{#8}{}}
                }
                {}
                {#8}
            }
            {}

        #4
        
        \ifbool{fr}{
            #5 \CapitalizeCity{#6}
        }{
            \CapitalizeCity{#6}\newline #5
        }

        \ifthenelse { \equal{#1}{Sender} }
            {
                \ifthenelse { \equal{#7}{} } {} {#7}
                
                \ifthenelse { \equal{#8}{} } {} {\href{mailto:#8}{#8}}
            }
            {}
    \end{minipage}
}

\newcommand{\MakeEnHeader}[0]{
    \Stakeholder
        {Sender}
        {\SenderFirstName}
        {\SenderLastName}
        {\SenderAddress}
        {\SenderCityCode}
        {\SenderCity}
        {\SenderPhone}
        {\SenderEmail}

    \vskip 0.5cm

    \noindent
    \hspace{0.54\textwidth}%
    \begin{minipage}{0.45\textwidth}
        \today
    \end{minipage}

    \vskip 0.5cm

    \Stakeholder
        {Receiver}
        {\ReceiverFirstName}
        {\ReceiverLastName}
        {\ReceiverAddress}
        {\ReceiverCityCode}
        {\ReceiverCity}
        {\ReceiverDescription}
        {\ReceiverCompany}

    \vskip 1cm

    \noindent
    \textbf{Object: \Object}

    \noindent
    \ifthenelse { \equal{\Attachment}{} } {} {\textbf{Attachment: \Attachment}}

    \vskip 0.5cm
}

\newcommand{\MakeFrHeader}[0]{
    \Stakeholder
        {Sender}
        {\SenderFirstName}
        {\SenderLastName}
        {\SenderAddress}
        {\SenderCityCode}
        {\SenderCity}
        {\SenderPhone}
        {\SenderEmail}

    \vskip 0.5cm

    \noindent
    \Stakeholder
        {Receiver}
        {\ReceiverFirstName}
        {\ReceiverLastName}
        {\ReceiverAddress}
        {\ReceiverCityCode}
        {\ReceiverCity}
        {\ReceiverDescription}
        {\ReceiverCompany}

    \vskip 1cm

    \noindent
    \hspace{0.54\textwidth}
    \begin{minipage}{0.45\textwidth}
        À \FormatCity{\SendingPlace{}}, le \today
    \end{minipage}

    \vskip 1cm

    \noindent
    \textbf{Objet: \Object}

    \noindent
    \ifthenelse { \equal{\Attachment}{} } {} {\textbf{PJ: \Attachment}}

    \vskip 0.5cm
}

\newcommand{\makeheader}[0]{
    \ifbool{fr}{\MakeFrHeader}{\MakeEnHeader}
}

\newcommand{\sign}[0]{
    \ifbool{fr}{\vskip 1cm \hspace{0.5\textwidth}}{}%
    \noindent
    \FormatFirstName{\SenderFirstName} \FormatLastName{\SenderLastName}
}

% ============================================================================
% == Environments ==

% ============================================================================
% == Tests before begin document ==

\newcommand{\NoLanguageError}[0]{
    \ClassError{lettertemplate}
        {At least one language between "fr" and "en" must be specified in class options.}
        {}
}
\newcommand{\TooManyLanguagesError}[0]{
    \ClassError{lettertemplate}
        {Both "fr" and "en" class option cannot be specified at the same time.}
        {}
}

\newcommand{\TestNoLanguage}[0]{
    \ifboolexpr{not test {\ifbool{fr}} and not test {\ifbool{en}}}
        {\NoLanguageError}
        {}
}
\newcommand{\TestTooManyLanguages}[0]{
    \ifboolexpr{ test {\ifbool{fr}} and test {\ifbool{en}}}
        {\TooManyLanguagesError}
        {}
}

\BeforeBeginEnvironment{document}{
    \TestNoLanguage
    \TestTooManyLanguages
}

% ============================================================================
% == Tests at begin document ==

\newcommand{\NameError}[2]{
    \ClassError{lettertemplate}
        {Either both #1 and #2 must be empty, or both must be non-empty.}
        {}
}
\newcommand{\ReceiverError}[2]{
    \ClassError{lettertemplate}
        {ReceiverFirstName, ReceiverLastName, and ReceiverDescription are all empty.
        You must provide at least one of these three to generate the document}
        {}
}

\newcommand{\TestSenderName}[0]{
    \ifboolexpr{
        (test {\ifdefempty{\SenderFirstName}} and
        test {\ifdefempty{\SenderLastName}}) or
        (not test {\ifdefempty{\SenderFirstName}} and
        not test {\ifdefempty{\SenderLastName}})
    }
    {} 
    {\NameError{SenderFirstName}{SenderLastName}}
}

\newcommand{\TestReceiverName}[0]{
    \ifboolexpr{
        (test {\ifdefempty{\ReceiverFirstName}} and
        test {\ifdefempty{\ReceiverLastName}}) or
        (not test {\ifdefempty{\ReceiverFirstName}} and
        not test {\ifdefempty{\ReceiverLastName}})
    }
    {}
    {\NameError{ReceiverFirstName}{ReceiverLastName}}
}
\newcommand{\TestReceiver}[0]{
    \ifboolexpr{
        test {\ifdefempty{\ReceiverFirstName}} and
        test {\ifdefempty{\ReceiverLastName}} and
        test {\ifdefempty{\ReceiverDescription}}
    }
    {\ReceiverError}
    {\TestReceiverName}
}

\AtBeginEnvironment{document}{
    \TestReceiver
    \TestSenderName    
}

% ============================================================================
