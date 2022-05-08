import 'package:flutter/material.dart';
import 'package:the_movie_db/library/widgets/inherited/provider.dart';
import 'package:the_movie_db/widgets/auth/auth_model.dart';
import 'package:the_movie_db/widgets/auth/button_styles/blue_button_style.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Войти в свою учётную запись'),
      ),
      body: ListView(children: [
        _HeaderWidhet(),
      ]),
    );
  }
}

class _HeaderWidhet extends StatelessWidget {
  _HeaderWidhet({Key? key}) : super(key: key);
  final color = Color(0xFF01B4E4);

  @override
  Widget build(BuildContext context) {
    final OurTextStyle = TextStyle(
      fontSize: 16,
      color: Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          _FormWidget(),
          SizedBox(
            height: 25,
          ),
          Text(
            'Чтобы пользоваться правкой и возможностями рейтинга TMDB, а также получить персональные рекомендации, необходимо войти в свою учётную запись. Если у вас нет учётной записи, её регистрация является бесплатной и простой.',
            style: OurTextStyle,
          ),
          SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () {},
            child: Text('Регистрация'),
            style: BlueButtonStyle.linkButton,
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            'Если Вы зарегистрировались, но не получили письмо для подтверждения, нажмите здесь.',
            style: OurTextStyle,
          ),
          SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () {},
            child: Text('Подтвердить почту'),
            style: BlueButtonStyle.linkButton,
          )
        ],
      ),
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<AuthModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Имя пользователя',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          textInputAction: TextInputAction.next,
          controller: model?.loginTextController,
          //decoration: TextFieldStyle,
        ),
        SizedBox(height: 20),
        Text(
          'Пароль',
          //style: OurTextStyle,
        ),
        SizedBox(height: 4),
        TextField(
          controller: model?.passwordTextController,
          //decoration: TextFieldStyle,
          obscureText: true,
        ),
        _ErrorMessageWidget(),
        Row(
          children: [
            _AuthButtonWidget(),
            SizedBox(
              width: 30,
            ),
            TextButton(
              onPressed: () {},
              child: Text('Сбросить пароль'),
              style: BlueButtonStyle.linkButton,
            ),
          ],
        )
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<AuthModel>(context);
    const color = Color(0xFF01B4E4);
    final onPressed =
        model?.canStartAuth == true ? () => model?.auth(context) : null;
    final child = model?.isAuthProgress == true
        ? SizedBox(
            child: CircularProgressIndicator(),
            height: 15,
            width: 15,
          )
        : const Text('Войти');
    return TextButton(
      onPressed: onPressed,
      child: child,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          textStyle: MaterialStateProperty.all(
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 8,
          ))),
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage =
        NotifierProvider.watch<AuthModel>(context)?.errorMessage;
    if (errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        errorMessage,
        style: TextStyle(
          fontSize: 18,
          color: Colors.red,
        ),
      ),
    );
  }
}
